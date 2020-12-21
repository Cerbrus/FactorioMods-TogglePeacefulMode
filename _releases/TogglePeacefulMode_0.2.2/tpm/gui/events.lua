if not tpm.gui then error("Dependency missing: tpm.gui") end

--[[ Register button click event ]]--
script.on_event(defines.events.on_gui_click, function(event)
  tpm.debug("Event: on_gui_click")

  local name = event.element.name
  if (name == "tpm_mainbutton_peace" or name == "tpm_mainbutton_war" ) then
		tpm.toggle_peaceful(event)
  end
end)

--[[ Toggle peaceful mode ]]--
function tpm.toggle_peaceful(event)
  tpm.debug("Function call: toggle_peaceful")

  local previousState = tpm.is_peaceful()
  local player = game.players[event.player_index]

  tpm.set_peaceful(not previousState)
  tpm.reset_biters(event)

  if tpm.is_peaceful() then
    tpm.log("Peaceful mode enabled")
    tpm.gui.showPeaceButton(player)
  else
    tpm.log("Peaceful mode disabled")
    tpm.gui.showWarButton(player)
  end
end

--[[ Check peaceful mode ]]--
function tpm.is_peaceful()
  tpm.debug("Function call: is_peaceful")

  local is_peaceful = true;

  for _,s in pairs(game.surfaces) do
    is_peaceful = is_peaceful and s.peaceful_mode
  end

  return is_peaceful;
end

--[[ Set peaceful mode ]]--
function tpm.set_peaceful(peaceful)
  tpm.debug("Function call: set_peaceful")

  for _,s in pairs(game.surfaces) do
    s.peaceful_mode = peaceful;
  end
end

--[[ Reset biters to be peaceful / hostile (Kill all) ]]--
function tpm.reset_biters(event)
  tpm.debug("Function call: reset_biters")

  --[[ Some mods introduce biter factions. Kill'm! ]]--
  for k, force in pairs(game.forces) do
    if force.name:find("biter_faction_") == 1 then
      game.forces[force.name].kill_all_units()
    end
  end

  game.forces["enemy"].kill_all_units()
end
