if not tpm then error("Dependency missing: tpm core") end

--[[ Send the messages to all players ]]--
function tpm.log(msg)
  for _, player in pairs(game.players) do
    if player.valid then
      player.print(msg)
    end
  end
end

--[[ Send the messages to the player, if debug is enabled ]]--
function tpm.debug(msg, append)
  if tpm.showDebug then
    tpm.log(msg)
    game.write_file("tpm.txt", msg, append)
  end
end
