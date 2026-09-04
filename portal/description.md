# Toggle Peaceful Mode

**For feedback, please submit an issue [on the GitHub repository](https://github.com/Cerbrus/FactorioMods-TogglePeacefulMode/issues). I'm not getting notifications for messages submitted here.**

This mod allows you to toggle "[Peaceful mode](https://wiki.factorio.com/index.php?title=World_generator&redirect=no#Enemy)" at will, on every surface. Space Age planets and space platforms are included, also the ones you visit after toggling.

Normally, toggling peaceful mode through a lua command disables achievements for the save:
`/c game.player.surface.peaceful_mode = true / false`
This mod lets you circumvent that.

**About achievements:** this only keeps Factorio's *in-game* achievements enabled. Steam achievements are disabled by Factorio whenever any mod is active, and this mod is no exception. If you want Steam achievements, toggle peaceful mode with this mod, then disable the mod again: the "peaceful" setting stays what it was last set to, and the save is unmodded again.

The mod shouldn't corrupt your save, but as always, back-up first.
(The author of this mod can't be held responsible for corrupted saves ;-) )

## Notes

- The toggle kills all mobile biters, spitters and Gleba pentapods, as their "peacefulness" is set when they spawn. They respawn from their spawners with the new setting.
- Demolishers on Vulcanus are **never** killed: they do not respawn. They don't need to be, they follow the setting live. In peaceful mode they ignore new buildings in their territory; switch back and they attack them again. A demolisher that is already charging a building when you toggle finishes that attack first.
- Toggling is announced in chat with the name of the player who toggled.
- Modded biter factions are supported as long as their force's name starts with `biter_faction_`. If there are modded factions this doesn't work with, please let me know!
