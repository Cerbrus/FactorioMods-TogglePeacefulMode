data:extend({
  -- Shortcut-bar button (bottom of the screen, next to the blueprint tools).
  -- Toggled state and availability are driven from the control stage (tpm/shortcut.lua).
  {
    type = "shortcut",
    name = "tpm-toggle-peaceful",
    order = "z[tpm]-a[toggle-peaceful]",
    action = "lua",
    toggleable = true,
    associated_control_input = "tpm-toggle-peaceful",
    icon = "__TogglePeacefulMode__/graphics/shortcut.png",
    icon_size = 32,
    small_icon = "__TogglePeacefulMode__/graphics/shortcut-small.png",
    small_icon_size = 24,
  },
  -- Hotkey, unbound by default; players can bind it under Settings → Controls → Mods.
  {
    type = "custom-input",
    name = "tpm-toggle-peaceful",
    key_sequence = "",
    action = "lua",
  },
})
