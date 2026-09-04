if not tpm then error("Dependency missing: tpm core") end

--[[ Derive the peaceful state from the surfaces that currently exist.
     Only used when the mod has no stored state yet (first install). ]]--
function tpm.surfaces_peaceful()
  for _, surface in pairs(game.surfaces) do
    if not surface.peaceful_mode then return false end
  end
  return true
end

--[[ Check peaceful mode. `storage.peaceful` is the single source of truth. ]]--
function tpm.is_peaceful()
  if storage.peaceful == nil then
    storage.peaceful = tpm.surfaces_peaceful()
  end
  return storage.peaceful
end

--[[ Apply the stored peaceful state to every existing surface ]]--
function tpm.apply_peaceful()
  local peaceful = tpm.is_peaceful()
  for _, surface in pairs(game.surfaces) do
    surface.peaceful_mode = peaceful
  end
end

--[[ Keep the "Peaceful mode" map setting equal to the stored state ]]--
function tpm.sync_setting()
  local peaceful = tpm.is_peaceful()
  if settings.global["tpm-peaceful"].value ~= peaceful then
    settings.global["tpm-peaceful"] = { value = peaceful }
  end
end

--[[ Whether this player may toggle. Admin-only unless the map setting opens it up. ]]--
function tpm.can_toggle(player)
  return player.admin or not settings.global["tpm-admin-only"].value
end

--[[ Player pressed the shortcut or hotkey ]]--
function tpm.request_toggle(player)
  if not player then return end
  if not tpm.can_toggle(player) then
    player.print({ "tpm.admin-only" })
    tpm.shortcut.sync(player)
    return
  end
  tpm.set_peaceful(not tpm.is_peaceful(), player)
end

--[[ Set peaceful mode everywhere, reset enemies, and tell everyone.
     `player` is who did it (nil when changed from the server console). ]]--
function tpm.set_peaceful(peaceful, player)
  storage.peaceful = peaceful
  tpm.apply_peaceful()
  tpm.reset_biters()
  tpm.sync_setting()
  tpm.shortcut.sync_all()

  local state = { peaceful and "tpm.state-on" or "tpm.state-off" }
  if player then
    game.print({ "tpm.announce-player", player.name, state })
  else
    game.print({ "tpm.announce", state })
  end
end

--[[ Reset biters to be peaceful / hostile (Kill all).
     Units (biters, spitters, pentapods) keep the peacefulness they spawned with, so they are
     killed and respawn from their spawners with the new setting.
     Demolishers (segmented-unit) are deliberately left alone: they never respawn, and they
     follow the surface setting live anyway. ]]--
function tpm.reset_biters()
  --[[ Some mods introduce biter factions. Kill'm! ]]--
  for _, force in pairs(game.forces) do
    if force.name:find("biter_faction_") == 1 then
      force.kill_all_units()
    end
  end

  game.forces["enemy"].kill_all_units()
end
