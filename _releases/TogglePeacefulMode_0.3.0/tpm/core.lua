tpm = { showDebug = false }

require "tpm.logger"
require "tpm.gui"

--[[ On mod init ]]--
script.on_init(function()
  local peaceful = tpm.is_peaceful()
	for _, player in pairs(game.players) do
		tpm.gui.init(player, peaceful)
	end
end)

--[[ When a player joins ]]--
script.on_event(defines.events.on_player_created, function(event)
	tpm.gui.init(game.players[event.player_index], tpm.is_peaceful())
end)
