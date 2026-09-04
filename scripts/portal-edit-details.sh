#!/usr/bin/env bash
# Push the mod portal page details from the repository to mods.factorio.com:
#   description  <- portal/description.md (markdown)
#   title        <- info.json "title"
#   summary      <- info.json "description"  (portal limit: 500 chars)
#   homepage     <- info.json "homepage"
#   source_url   <- the GitHub repository
#
# Requires FACTORIO_API_KEY in the environment, with the "ModPortal: Edit Mods" usage.
# API: https://wiki.factorio.com/Mod_details_API

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

: "${FACTORIO_API_KEY:?FACTORIO_API_KEY is not set}"

name="$(jq -r .name info.json)"
title="$(jq -r .title info.json)"
summary="$(jq -r .description info.json)"
homepage="$(jq -r .homepage info.json)"
source_url="https://github.com/Cerbrus/FactorioMods-TogglePeacefulMode"

if [ "${#summary}" -gt 500 ]; then
  echo "error: info.json description is ${#summary} chars; the portal summary allows 500" >&2
  exit 1
fi

response="$(curl -sS -w $'\n%{http_code}' -X POST \
  -H "Authorization: Bearer $FACTORIO_API_KEY" \
  -F "mod=$name" \
  -F "title=$title" \
  -F "summary=$summary" \
  -F "homepage=$homepage" \
  -F "source_url=$source_url" \
  -F "description=<portal/description.md" \
  https://mods.factorio.com/api/v2/mods/edit_details)"
status="${response##*$'\n'}"
body="${response%$'\n'*}"

if [ "$status" != "200" ]; then
  echo "error: edit_details returned HTTP $status: $body" >&2
  exit 1
fi

echo "$body" | jq .
echo "Updated https://mods.factorio.com/mod/$name"
