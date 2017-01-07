if not tpm.gui then error("Dependency missing: tpm.gui") end

--[[ Init Gui ]]--
function tpm.gui.init(player, peaceful)
  tpm.debug("Function call: gui.init")
  
  if peaceful then
    tpm.gui.showPeaceButton(player)
  else
    tpm.gui.showWarButton(player)
  end
end

--[[ Gets a button by name ]]--
function tpm.gui.getButton(player, button)
  tpm.debug("Function call: getButton")
  
  if (not player or not player.valid) then
    return nil
  end
  if (player.gui.top[button] ~= nil) then
    return player.gui.top[button]
  end
  
  return nil
end

--[[ Removes all tpm buttons ]]--
function tpm.gui.removeButtons(player)
  tpm.debug("Function call: removeButtons")
  
  local peaceButton = tpm.gui.getButton(player, "tpm_mainbutton_peace")
  if peaceButton then peaceButton.destroy() end
  
  local warButton = tpm.gui.getButton(player, "tpm_mainbutton_war")
  if warButton then warButton.destroy() end
end

--[[ Shows the [name] button ]]--
function tpm.gui.showButton(player, name)
  tpm.debug("Function call: showButton")
  
  tpm.gui.removeButtons(player)
  player.gui.top.add{ type = "sprite-button", name = "tpm_mainbutton_" .. name, caption = "TPM", sprite = "tpm_button_sprite_" .. name, style = "tpm_button" }
end

--[[ Shows the peace button ]]--
function tpm.gui.showPeaceButton(player)
  tpm.debug("Function call: showPeaceButton")
  tpm.gui.showButton(player, "peace")
end

--[[ Shows the war button ]]--
function tpm.gui.showWarButton(player)
  tpm.debug("Function call: showWarButton")
  tpm.gui.showButton(player, "war")
end