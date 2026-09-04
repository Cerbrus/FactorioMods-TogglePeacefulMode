# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Factorio 2.0 mod (`TogglePeacefulMode`) written in Lua. It adds a `mod-gui` button that toggles `peaceful_mode` on every surface without disabling achievements. Toggling also kills all mobile enemy units (via `force.kill_all_units()`), because a biter's peacefulness is fixed at spawn.

There is no build system, linter, or test suite. The mod is plain Lua loaded by Factorio; the only way to test is to install it into Factorio's `mods/` folder and run the game (`_releases/mods.lnk` is a shortcut to that folder).

## Architecture

Factorio loads mods in two separate stages, and the repo is split accordingly:

- **Data stage** (`data.lua` → `prototypes/style.lua`): registers the two `sprite` prototypes (`tpm_button_sprite_peace` / `tpm_button_sprite_war`) that the button uses. Referenced via `__TogglePeacefulMode__/graphics/*.png`.
- **Control stage** (`control.lua` → `tpm/core.lua`): all runtime logic. Everything hangs off a single global table `tpm`, which `tpm/core.lua` creates first (`tpm = { showDebug = false }`) and every other file asserts exists before running.

Control-stage module layout under `tpm/`:

- `core.lua` – creates `tpm`, requires `logger` and `gui`, and registers `on_init` / `on_player_created` to add the button for each player.
- `gui.lua` – creates `tpm.gui` and requires `gui/layout.lua` and `gui/events.lua`. Note the `require` paths here are relative (`"gui.layout"`), whereas `control.lua` / `core.lua` use `"tpm.xxx"`.
- `gui/layout.lua` – `tpm.gui.init(player, peaceful)`: adds the `tpm-button` sprite-button to `mod_gui.get_button_flow(player)`, returning the existing one if already present (fix for duplicate buttons).
- `gui/events.lua` – `on_gui_click` handler plus the game-state functions `tpm.is_peaceful()` (AND across all surfaces), `tpm.set_peaceful(bool)` (sets all surfaces), and `tpm.reset_biters()` (kills units of `enemy` and any force whose name starts with `biter_faction_`).
- `logger.lua` – `tpm.log` (print to all players) and `tpm.debug` (only when `tpm.showDebug` is true; also writes `tpm.txt` via `game.write_file`).

`migrations/TogglePeacefulMode_0.3.0.lua` removes the pre-0.3.0 `player.gui.top` buttons and re-creates the `mod-gui` button. Add a new migration file (named `TogglePeacefulMode_<version>.lua`) when a version changes saved GUI state.

## Linting and packaging

- `luacheck .` — config in `.luacheckrc` (Factorio globals declared there; `tpm`, `mod_gui` and `storage` are the mod's own globals). CI runs this on every push/PR.
- `scripts/package.sh` — builds `dist/TogglePeacefulMode_<version>.zip` with the exact file list that ships (the list is explicit in the script; add new top-level folders such as `locale/` there). Needs `jq` and `zip` or `python3`.

## Releasing

Releases are automated by `.github/workflows/release.yml`:

1. Bump `version` in `info.json` and add a matching `Version: x.y.z` block at the top of `changelog.txt` (Factorio changelog format: 99-dash separators, `  Category:` lines, `    - entry` lines).
2. Commit, tag `vX.Y.Z`, push the tag.
3. The workflow verifies tag == `info.json` version, packages, creates a GitHub Release (notes = that changelog section, zip attached) and uploads the zip to the mod portal using the `FACTORIO_API_KEY` secret.

Historic zips (0.1.0–0.3.2) live on the GitHub Releases page; `_releases/` is gone and gitignored.
