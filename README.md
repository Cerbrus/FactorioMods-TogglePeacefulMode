# Toggle Peaceful Mode

This [Factorio](https://factorio.com/) mod allows you to toggle "[Peaceful mode](https://wiki.factorio.com/index.php?title=World_generator#Enemy)" at will.

Normally, toggling peaceful mode through a lua command disables achievements for the save:
`/c game.player.surface.peaceful_mode = true / false`
This mod lets you circumvents that.

If you disable the mod, the "peaceful" setting will still be what it was last set to. This allows you to disable "peaceful" mode while keeping steam achievements enabled for non-modded games.

The mod shouldn't corrupt your save, but as always, back-up first.
<sup><sub>(The author of this mod can 't be held responsible for corrupted saves ;-) )</sub></sup>

Note: The toggle will kill all (mobile) biters, as their "peacefulness" is set when they spawn. Afaik, this can't be updated.

# How to Use

Choose one of the following installation methods:

* Install using Factorio's built-in mod manager
    * From the main menu click on "Mods", then on the "Install" tab
    * Click on 🔎 button, search for (or just magically find), and select "Toggle Peaceful Mode"
    * Click on the "Install" button, then the green "Confirm" button
    * Factorio will restart with the new mod installed. Have fun :D
* Manually, by [downloading the mod zip file from GitLab](https://gitlab.com/lexxyfox/TogglePeacefulMode/-/jobs/artifacts/foxxo/browse?job=build_job) and placing it in your mods folder
* Using the command line:
```
curl -L https://gitlab.com/lexxyfox/TogglePeacefulMode/-/jobs/artifacts/foxxo/download?job=build_job | bsdtar -xvf- -C ~/.factorio/mods
```
* By compiling from source! (described below)

# Compiling

In addition to a POSIX system, you must have the following commands available:

* jq
* make
* optipng
* rsvg-convert
* zip

Download using git perferably (svn also works):

```
git clone https://github.com/Higgs1/TogglePeacefulMode
```

If you've cloned this repo into your Factorio mods folder, you can simply run the following command in the root source folder:

```
make -j
```

All done! Start up Factorio and have fun. If instead you want a zip file produced, run:

```
make -j zip
```

This will output the mod's zip file in the root source directory. The mod's version number will be pulled from info.json. Alternatively you may run:

```
make -j install
```

... and the resulting zip file will be automatically inserted into your Factorio's mod folder (~/.factorio/mods). Useful if you've cloned the repo outside of your mods folder.

```
make clean
```

You know what this does! :P

# Notes

This mod should work with some modded biter factions, as long as their force's name starts with "biter_faction_". If there are modded factions this doesn't work with, please let me know!
