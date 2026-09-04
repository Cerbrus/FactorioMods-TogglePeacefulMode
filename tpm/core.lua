tpm = { showDebug = false }

require "tpm.logger"
require "tpm.state"
require "tpm.shortcut"

local SHORTCUT = "tpm-toggle-peaceful"

--[[ Full sync of everything derived from the stored state: surfaces, mod setting, shortcut bars ]]--
local function sync_all()
  tpm.apply_peaceful()
  tpm.sync_setting()
  tpm.shortcut.sync_all()
end

--[[ On mod init (new game, or mod added to an existing save) ]]--
script.on_init(function()
  storage.peaceful = tpm.surfaces_peaceful()
  sync_all()
end)

--[[ Mod or game version changed ]]--
script.on_configuration_changed(sync_all)

--[[ Planet surfaces and space platforms are only created when first visited.
     Apply the stored state so they don't fall back to the map-gen default. ]]--
script.on_event(defines.events.on_surface_created, function(event)
  local surface = game.get_surface(event.surface_index)
  if surface then
    surface.peaceful_mode = tpm.is_peaceful()
  end
end)

--[[ Keep each player's shortcut state and availability current ]]--
local function sync_player(event)
  local player = game.get_player(event.player_index)
  if player then
    tpm.shortcut.sync(player)
  end
end

script.on_event(defines.events.on_player_created, sync_player)
script.on_event(defines.events.on_player_joined_game, sync_player)
script.on_event(defines.events.on_player_promoted, sync_player)
script.on_event(defines.events.on_player_demoted, sync_player)

--[[ Shortcut-bar button ]]--
script.on_event(defines.events.on_lua_shortcut, function(event)
  if event.prototype_name == SHORTCUT then
    tpm.request_toggle(game.get_player(event.player_index))
  end
end)

--[[ Hotkey (custom input, unbound by default) ]]--
script.on_event(SHORTCUT, function(event)
  tpm.request_toggle(game.get_player(event.player_index))
end)

--[[ Mod Settings → Map ]]--
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if event.setting == "tpm-peaceful" then
    local desired = settings.global["tpm-peaceful"].value
    if desired ~= tpm.is_peaceful() then
      local player = event.player_index and game.get_player(event.player_index) or nil
      tpm.set_peaceful(desired, player)
    end
  elseif event.setting == "tpm-admin-only" then
    tpm.shortcut.sync_all()
  end
end)
