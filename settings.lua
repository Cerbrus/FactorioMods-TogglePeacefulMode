data:extend({
  -- Mirrors the current peaceful state (Mod Settings → Map). Changing it there toggles the mode
  -- exactly like the shortcut does; the mod keeps it in sync when the shortcut is used.
  {
    type = "bool-setting",
    name = "tpm-peaceful",
    setting_type = "runtime-global",
    default_value = false,
    order = "a",
  },
  -- Multiplayer: restrict the shortcut and hotkey to admins.
  {
    type = "bool-setting",
    name = "tpm-admin-only",
    setting_type = "runtime-global",
    default_value = true,
    order = "b",
  },
})
