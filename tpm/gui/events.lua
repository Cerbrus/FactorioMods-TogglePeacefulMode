mod_gui = require("mod-gui")

if not tpm.gui then error("Dependency missing: tpm.gui") end

--[[ Register button click event ]]--
script.on_event(defines.events.on_gui_click, function(event)
  tpm.debug("Event: on_gui_click")

  if event.element.name == "tpm-button" then
    local player = game.players[event.player_index]
    local peaceful = not tpm.is_peaceful()

    tpm.set_peaceful(peaceful)
    tpm.reset_biters()

    game.print(player.name .. " turned peaceful mode " .. (peaceful and "on" or "off") .. ".")
  end
end)

--[[ Derive the peaceful state from the surfaces that currently exist.
     Only used when the mod has no stored state yet (first install). ]]--
function tpm.surfaces_peaceful()
  for _, surface in pairs(game.surfaces) do
    if not surface.peaceful_mode then return false end
  end
  return true
end

--[[ Check peaceful mode. `storage.peaceful` is the single source of truth. ]]--
function tpm.is_peaceful()
  if storage.peaceful == nil then
    storage.peaceful = tpm.surfaces_peaceful()
  end
  return storage.peaceful
end

--[[ Apply the stored peaceful state to every existing surface ]]--
function tpm.apply_peaceful()
  local peaceful = tpm.is_peaceful()
  for _, surface in pairs(game.surfaces) do
    surface.peaceful_mode = peaceful
  end
end

--[[ Set peaceful mode on all surfaces and update every player's button ]]--
function tpm.set_peaceful(peaceful)
  tpm.debug("Function call: set_peaceful")

  storage.peaceful = peaceful
  tpm.apply_peaceful()
  tpm.gui.update_all()
end

--[[ Reset biters to be peaceful / hostile (Kill all).
     Units (biters, spitters, pentapods) keep the peacefulness they spawned with, so they are
     killed and respawn from their spawners with the new setting.
     Demolishers (segmented-unit) are deliberately left alone: they never respawn. ]]--
function tpm.reset_biters()
  tpm.debug("Function call: reset_biters")

  --[[ Some mods introduce biter factions. Kill'm! ]]--
  for _, force in pairs(game.forces) do
    if force.name:find("biter_faction_") == 1 then
      force.kill_all_units()
    end
  end

  game.forces["enemy"].kill_all_units()
end
