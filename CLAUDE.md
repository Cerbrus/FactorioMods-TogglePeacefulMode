# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Factorio 2.1 mod (`TogglePeacefulMode`) written in Lua. It adds a shortcut-bar toggle (plus an unbound hotkey and a map setting) that flips `peaceful_mode` on every surface without disabling in-game achievements. Toggling also kills all mobile enemy units (via `force.kill_all_units()`), because a biter's peacefulness is fixed at spawn.

There is no test suite. The mod is plain Lua loaded by Factorio; test by linking the repo into Factorio's `mods/` folder (see README) and running the game. Local Factorio is 2.1.

## Architecture

Factorio loads mods in three stages, and the repo is split accordingly:

- **Settings stage** (`settings.lua`): two `runtime-global` bool settings, `tpm-peaceful` (mirror of the state, so Mod Settings → Map can toggle it) and `tpm-admin-only` (default true).
- **Data stage** (`data.lua` → `prototypes/shortcut.lua`): the `shortcut` prototype `tpm-toggle-peaceful` (`action = "lua"`, `toggleable`, 32px `icon` + 24px `small_icon` from `graphics/`; `graphics/shortcut.svg` is the source, not shipped) and a `custom-input` of the same name (unbound).
- **Control stage** (`control.lua` → `tpm/core.lua`): all runtime logic. Everything hangs off a single global table `tpm`, which `tpm/core.lua` creates first and every other file asserts exists before running.

State: `storage.peaceful` (Factorio's persistent mod table) is the single source of truth. `tpm.is_peaceful()` reads it (deriving it from existing surfaces once if unset), `tpm.set_peaceful(bool, player)` writes it and then pushes it everywhere: all surfaces, the `tpm-peaceful` setting, every player's shortcut toggled state, plus the enemy reset and a chat announcement. `on_surface_created` applies it to surfaces created later (Space Age planets and platforms are created lazily on first visit). Never derive state from surfaces except through `tpm.surfaces_peaceful()` on first install.

The setting mirror is two-way: `on_runtime_mod_setting_changed` calls `set_peaceful` when `tpm-peaceful` differs from the stored state, and `tpm.sync_setting()` writes the setting after every change. The handler is a no-op when they already agree, which is what prevents a loop.

Design constraint: the toggle must never kill demolishers (`segmented-unit`); they do not respawn. Only `force.kill_all_units()` (unit type) is used to reset enemies.

Control-stage module layout under `tpm/`:

- `core.lua` – creates `tpm`, requires `state` and `shortcut`, registers all events: `on_init`, `on_configuration_changed`, `on_surface_created`, player created/joined/promoted/demoted (shortcut sync), `on_lua_shortcut`, the custom input, `on_runtime_mod_setting_changed`.
- `state.lua` – `surfaces_peaceful`, `is_peaceful`, `apply_peaceful`, `sync_setting`, `can_toggle(player)` (admin or setting), `request_toggle(player)` (permission check + toggle), `set_peaceful`, `reset_biters`.
- `shortcut.lua` – `tpm.shortcut.sync(player)` sets toggled state and availability (`set_shortcut_available` = `can_toggle`); `sync_all()` for every player.

`locale/en/tpm.cfg` holds the shortcut, control and setting names plus the `[tpm]` messages. `migrations/TogglePeacefulMode_0.5.0.lua` removes the pre-0.5.0 GUI buttons (mod-gui and the even older top-bar ones). Add a new migration file (named `TogglePeacefulMode_<version>.lua`) when a version changes saved GUI state; migrations must not `require` control-stage modules.

## Linting and packaging

- `luacheck .` — config in `.luacheckrc` (Factorio globals declared there; `tpm`, `storage` and `settings` are declared writable). CI runs this on every push/PR.
- `scripts/package.sh` — builds `dist/TogglePeacefulMode_<version>.zip` with the exact file list that ships (the list is explicit in the script; add new top-level folders such as `locale/` there). Needs `jq` and `zip` or `python3`.

## Releasing

Releases are automated by `.github/workflows/release.yml`:

1. Bump `version` in `info.json` and add a matching `Version: x.y.z` block at the top of `changelog.txt` (Factorio changelog format: 99-dash separators, `  Category:` lines, `    - entry` lines).
2. Commit, tag `vX.Y.Z`, push the tag.
3. The workflow verifies tag == `info.json` version, packages, creates a GitHub Release (notes = that changelog section, zip attached) and uploads the zip to the mod portal using the `FACTORIO_API_KEY` secret.
4. If the portal upload fails, fix the cause (usually the secret) and re-run via Actions → Release → "Run workflow" with the existing tag; the GitHub Release step is skipped when the release already exists. The portal returns HTTP 400 with `InvalidApiKey` for a missing or wrong key.

Historic zips (0.1.0–0.3.2) live on the GitHub Releases page.

## Mod portal page text

`portal/description.md` is the portal's long description; `info.json` `title`/`description`/`homepage` feed the portal title, summary (max 500 chars) and homepage. `scripts/portal-edit-details.sh` pushes them via the `edit_details` API (key needs the "ModPortal: Edit Mods" usage); it runs from `portal-details.yml` on master pushes touching those files and at the end of every release. Never edit the portal page by hand; change these files. `portal/` is not packaged into the mod zip.