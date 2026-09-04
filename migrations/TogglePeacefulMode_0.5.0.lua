-- 0.5.0 replaced the on-screen button with a shortcut-bar toggle. Remove the old buttons:
-- the mod-gui button (0.3.0 – 0.4.0) and the top-bar buttons from before 0.3.0.
local mod_gui = require("mod-gui")

for _, player in pairs(game.players) do
  local button = mod_gui.get_button_flow(player)["tpm-button"]
  if button then button.destroy() end

  for _, name in ipairs({ "tpm_mainbutton_peace", "tpm_mainbutton_war" }) do
    local legacy = player.gui.top[name]
    if legacy then legacy.destroy() end
  end
end
