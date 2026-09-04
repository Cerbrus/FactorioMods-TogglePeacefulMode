#!/usr/bin/env bash
# Package the mod into dist/<name>_<version>.zip, laid out the way Factorio expects:
#   <name>_<version>.zip
#   └── <name>_<version>/
#       ├── info.json
#       └── ...
#
# Usage: scripts/package.sh            (from anywhere; output goes to <repo>/dist/)
# Prints the path of the created zip on stdout.

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# Python is only a fallback for local use when jq/zip are missing (CI runners have both).
# On Windows "python3" may be a Store stub that exits non-zero, so probe before using it.
python_bin() {
  local py
  for py in python3 python; do
    if "$py" -c "" >/dev/null 2>&1; then echo "$py"; return; fi
  done
  echo "error: need jq/zip or a working python" >&2; exit 1
}

# Read a top-level string field from info.json.
json_field() {
  if command -v jq >/dev/null 2>&1; then
    jq -r ".$1" info.json
  else
    "$(python_bin)" -c "import json,sys; print(json.load(open('info.json'))[sys.argv[1]])" "$1"
  fi
}

name="$(json_field name)"
version="$(json_field version)"
folder="${name}_${version}"
zip_name="${folder}.zip"

rm -rf "build/$folder" "dist/$zip_name"
mkdir -p "build/$folder" dist

# Files and folders that go into the release. Keep this list explicit so stray
# repo files (CI config, docs, source PSDs, ...) never end up on the mod portal.
copy() { # copy <path>  (file or directory, relative to repo root)
  if [ -d "$1" ]; then
    mkdir -p "build/$folder/$1"
    cp -R "$1"/. "build/$folder/$1/"
  elif [ -f "$1" ]; then
    cp "$1" "build/$folder/$1"
  fi
}

copy info.json
copy control.lua
copy data.lua
copy settings.lua
copy changelog.txt
copy README.md
copy thumbnail.png
copy graphics
copy locale
copy migrations
copy prototypes
copy tpm

# Source assets are not needed in-game.
find "build/$folder" \( -name '*.psd' -o -name '*.svg' \) -delete

(
  cd build
  if command -v zip >/dev/null 2>&1; then
    zip -qr "../dist/$zip_name" "$folder"
  else
    "$(python_bin)" -m zipfile -c "../dist/$zip_name" "$folder"
  fi
)

echo "dist/$zip_name"
