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

1. Start Factorio.
1. Open the "Mod" menu.
1. Search for the "Toggle Peaceful Mode" mod.
1. Install the mod.
1. Use the button on the top-left to toggle peaceful mode at will.

# Compiling

In addition to a POSIX system, you must have the following commands available:

* jq
* make
* optipng
* rsvg-convert
* zip

To compile, just run:

```
make -j zip
```

This will output the mod's zip file in the source's root directory. The mod's version number will be pulled from info.json. Alternatively you may run:

```
make -j install
```

... and the mod will be automatically inserted into your Factorio's (default) mod folder.

```
make clean
```

You know what this does! :P

# Notes

This mod should work with some modded biter factions, as long as their force's name starts with "biter_faction_". If there are modded factions this doesn't work with, please let me know!
