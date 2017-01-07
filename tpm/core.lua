tpm = { showDebug = false }

require "tpm.logger"
require "tpm.helpers"
require "tpm.gui"

--[[ On mod init ]]--
script.on_init(function()
  tpm.debug("Function call: on_init")
  
  local peaceful = tpm.is_peaceful()
  
	for _, player in pairs(game.players) do
		tpm.gui.init(player, peaceful)
	end
end)


--[[ When a player joins ]]--
script.on_event(defines.events.on_player_created, function(event)
  tpm.debug("Function call: on_player_created")
  
  local peaceful = tpm.is_peaceful()
  
	tpm.gui.init(game.players[event.player_index], peaceful)
end)