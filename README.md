# Toggle Peaceful Mode

[![CI](https://github.com/Cerbrus/FactorioMods-TogglePeacefulMode/actions/workflows/ci.yml/badge.svg)](https://github.com/Cerbrus/FactorioMods-TogglePeacefulMode/actions/workflows/ci.yml)
[![Mod portal](https://img.shields.io/badge/mod%20portal-TogglePeacefulMode-orange)](https://mods.factorio.com/mod/TogglePeacefulMode)

This [Factorio](https://factorio.com/) mod allows you to toggle "[Peaceful mode](https://wiki.factorio.com/index.php?title=World_generator#Enemy)" at will.

Normally, toggling peaceful mode through a lua command disables achievements for the save:
`/c game.player.surface.peaceful_mode = true / false`
This mod lets you circumvent that.

**About achievements:** this only keeps Factorio's *in-game* achievements enabled. Steam achievements are disabled by Factorio whenever any mod is active, and this mod is no exception. If you want Steam achievements, toggle peaceful mode with this mod, then disable the mod again: the "peaceful" setting stays what it was last set to, and the save is unmodded again.

The mod shouldn't corrupt your save, but as always, back-up first.
<sup><sub>(The author of this mod can't be held responsible for corrupted saves ;-) )</sub></sup>

Note: The toggle will kill all (mobile) biters, spitters and Gleba pentapods, as their "peacefulness" is set when they spawn. They respawn from their spawners with the new setting.

Demolishers on Vulcanus are **never** killed by this mod: they do not respawn, so killing them would remove them from the planet for good. They don't need to be: demolishers follow the surface setting live. In peaceful mode they ignore new buildings in their territory; switch back and they attack them again. The one exception is a demolisher that is already charging a building when you toggle: it finishes that attack first.

# How to Use

1. Start Factorio.
2. Open the "Mod" menu.
3. Search for the "Toggle Peaceful Mode" mod.
4. Install the mod.
5. Use the button on the top-left to toggle peaceful mode at will.

# Notes

This mod should work with some modded biter factions, as long as their force's name starts with "biter_faction_". If there are modded factions this doesn't work with, please let me know!

# Development

## Running from source

Link the repository into Factorio's mods folder; the folder name must match the mod name (`TogglePeacefulMode`):

```powershell
# Windows (junction, no admin rights needed)
New-Item -ItemType Junction -Path "$env:APPDATA\Factorio\mods\TogglePeacefulMode" -Target "C:\path\to\this\repo"
```

```sh
# Linux / macOS
ln -s /path/to/this/repo ~/.factorio/mods/TogglePeacefulMode
```

Factorio picks the mod up on the next start. Control-stage changes (`tpm/`) need a save reload; data-stage changes (`prototypes/`, `info.json`) need a game restart.

## Linting and packaging

- `luacheck .` — configuration in `.luacheckrc`. Runs in CI on every push and pull request.
- `scripts/package.sh` — builds `dist/TogglePeacefulMode_<version>.zip` exactly as it will be released. Needs `jq` and `zip` (or `python3` as a fallback for both).

## Releasing

Releases are automated. Old release zips are on the [Releases](https://github.com/Cerbrus/FactorioMods-TogglePeacefulMode/releases) page.

1. Bump `version` in `info.json`.
2. Add a matching `Version: x.y.z` block at the top of `changelog.txt` ([format](https://lua-api.factorio.com/latest/auxiliary/changelog-format.html)).
3. Commit, then tag and push the tag:

   ```sh
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

The [release workflow](.github/workflows/release.yml) verifies that the tag matches `info.json`, packages the mod, creates a GitHub Release with that version's changelog section as notes, and uploads the zip to the [mod portal](https://mods.factorio.com/mod/TogglePeacefulMode).
