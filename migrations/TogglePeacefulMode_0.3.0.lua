local peaceful = is_peaceful()

for _, player in pairs(game.players) do
  local peaceButton = player.gui.top["tpm_mainbutton_peace"]
  if peaceButton then peaceButton.destroy() end

  local warButton = player.gui.top["tpm_mainbutton_war"]
  if warButton then warButton.destroy() end
  
	add_button(player, peaceful)
end
