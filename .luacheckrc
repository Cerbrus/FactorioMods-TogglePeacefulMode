-- Luacheck configuration for a Factorio mod.
-- Run locally with: luacheck .   (https://github.com/lunarmodules/luacheck)

std = "lua52"
max_line_length = 120
codes = true

exclude_files = {
  "_releases/",
  "build/",
  "dist/",
}

-- Factorio runtime API (read-only)
read_globals = {
  -- data stage
  "data", "mods",
  -- control stage
  "game", "script", "defines", "remote", "commands", "rendering", "rcon",
  "helpers", "prototypes",
  "log", "localised_print", "serpent", "table_size",
  -- lualib
  "util",
}

-- Globals this mod defines itself
globals = {
  "storage",   -- Factorio's persistent mod table (2.0)
  "settings",  -- settings.global[...] is written to in tpm/state.lua
  "tpm",       -- mod namespace, created in tpm/core.lua
}

files["migrations/*.lua"] = {
  -- migrations run as chunks with the same environment as control.lua
}
