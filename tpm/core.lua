tpm = { showDebug = false }

require "tpm.logger"
require "tpm.gui"

--[[ On mod init (new game, or mod added to an existing save) ]]--
script.on_init(function()
  storage.peaceful = tpm.surfaces_peaceful()
  for _, player in pairs(game.players) do
    tpm.gui.init(player, storage.peaceful)
  end
end)

--[[ Mod or game version changed: make sure the stored state exists and every surface matches it ]]--
script.on_configuration_changed(function()
  tpm.apply_peaceful()
  tpm.gui.update_all()
end)

--[[ Planet surfaces and space platforms are only created when first visited.
     Apply the stored state so they don't fall back to the map-gen default. ]]--
script.on_event(defines.events.on_surface_created, function(event)
  local surface = game.get_surface(event.surface_index)
  if surface then
    surface.peaceful_mode = tpm.is_peaceful()
  end
end)

--[[ When a player joins ]]--
script.on_event(defines.events.on_player_created, function(event)
  tpm.gui.init(game.players[event.player_index], tpm.is_peaceful())
end)
