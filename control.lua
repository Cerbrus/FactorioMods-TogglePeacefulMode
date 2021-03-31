mod_gui = require("mod-gui")

function is_peaceful()
  for _, s in pairs(game.surfaces) do
    if not s.peaceful_mode then
      return
    end
  end

  return true;
end

function add_button(player, peaceful)
  local flow = mod_gui.get_button_flow(player)
  return flow["tpm-button"] or flow.add{
    type = "sprite-button",
    name = "tpm-button",
    style = "mod_gui_button",
    sprite = is_peaceful() and "tpm_button_sprite_peace" or "tpm_button_sprite_war"
  }
end

script.on_event(defines.events.on_gui_click, function(event)
  if (event.element.name == "tpm-button") then
    local peaceful = is_peaceful()
    
    for _, p in pairs(game.players) do
      mod_gui.get_button_flow(p)["tpm-button"].sprite = 
        peaceful and "tpm_button_sprite_war" or "tpm_button_sprite_peace"
    end

    for _, s in pairs(game.surfaces) do
      s.peaceful_mode = not peaceful;
    end
    
    for _, f in pairs(game.forces) do
      if f.name:find("biter_faction_") == 1 then
        f.kill_all_units()
      end
    end
    
    game.forces["enemy"].kill_all_units()
  end
end)

script.on_init(function()
  local peaceful = is_peaceful()
	for _, player in pairs(game.players) do
		add_button(player, peaceful)
	end
end)

script.on_event(defines.events.on_player_created, function(event)
	add_button(game.players[event.player_index], is_peaceful())
end)
