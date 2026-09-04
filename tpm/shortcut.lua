if not tpm then error("Dependency missing: tpm core") end

tpm.shortcut = {}

local SHORTCUT = "tpm-toggle-peaceful"

--[[ Make one player's shortcut-bar button reflect the stored state and their permission ]]--
function tpm.shortcut.sync(player)
  player.set_shortcut_toggled(SHORTCUT, tpm.is_peaceful())
  player.set_shortcut_available(SHORTCUT, tpm.can_toggle(player))
end

--[[ Same, for every player ]]--
function tpm.shortcut.sync_all()
  for _, player in pairs(game.players) do
    tpm.shortcut.sync(player)
  end
end
