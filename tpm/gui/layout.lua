mod_gui = require("mod-gui")

if not tpm.gui then error("Dependency missing: tpm.gui") end

--[[ Init Gui ]]--
function tpm.gui.init(player, peaceful)
  local mod_gui_button = mod_gui.get_button_flow(player).add{
    type = "sprite-button",
    name = "tpm-button",
    style = "mod_gui_button",
    sprite = tpm.is_peaceful() and "tpm_button_sprite_peace" or "tpm_button_sprite_war"
  }
end
