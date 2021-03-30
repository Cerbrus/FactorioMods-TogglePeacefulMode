mod_gui = require("mod-gui")

function is_peaceful()
  local is_peaceful = true;

  for _, s in pairs(game.surfaces) do
    is_peaceful = is_peaceful and s.peaceful_mode
  end

  return is_peaceful;
end

function add_button(player, peaceful)
  local mod_gui_button = mod_gui.get_button_flow(player).add{
    type = "sprite-button",
    name = "tpm-button",
    style = "mod_gui_button",
    sprite = is_peaceful() and "tpm_button_sprite_peace" or "tpm_button_sprite_war"
  }
end

script.on_event(defines.events.on_gui_click, function(event)
  if (event.element.name == "tpm-button") then
    local peaceful = is_peaceful()
    local player = game.players[event.player_index]
    
    mod_gui.get_button_flow(game.players[event.player_index])["tpm-button"].sprite = 
      peaceful and "tpm_button_sprite_war" or "tpm_button_sprite_peace"

    for _,s in pairs(game.surfaces) do
      s.peaceful_mode = not peaceful;
    end
    
    for k, force in pairs(game.forces) do
      if force.name:find("biter_faction_") == 1 then
        force.kill_all_units()
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
