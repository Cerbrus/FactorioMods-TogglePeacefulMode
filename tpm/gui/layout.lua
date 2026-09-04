mod_gui = require("mod-gui")

if not tpm.gui then error("Dependency missing: tpm.gui") end

local function sprite_for(peaceful)
  return peaceful and "tpm_button_sprite_peace" or "tpm_button_sprite_war"
end

--[[ Init Gui ]]--
function tpm.gui.init(player, peaceful)
  local flow = mod_gui.get_button_flow(player)
  return flow["tpm-button"] or flow.add{
    type = "sprite-button",
    name = "tpm-button",
    style = "mod_gui_button",
    sprite = sprite_for(peaceful)
  }
end

--[[ Make every player's button reflect the current state ]]--
function tpm.gui.update_all()
  local peaceful = tpm.is_peaceful()
  for _, player in pairs(game.players) do
    local button = tpm.gui.init(player, peaceful)
    button.sprite = sprite_for(peaceful)
  end
end
