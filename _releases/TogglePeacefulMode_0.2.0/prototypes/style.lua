data.raw["gui-style"].default["tpm_button"] = {
  type = "button_style",
  parent = "button",
  width = 32,
  height = 32,
  top_padding = 0,
  right_padding = 0,
  bottom_padding = 0,
  left_padding = 0,
  left_click_sound = {{
    filename = "__core__/sound/gui-click.ogg",
    volume = 1
  }}
}

data:extend({
  {
    type = "sprite",
    name = "tpm_button_sprite_peace",
    filename = "__TogglePeacefulMode__/graphics/peace.png",
    priority = "extra-high-no-scale",
    width = 32,
    height = 32,
  },
  {
    type = "sprite",
    name = "tpm_button_sprite_war",
    filename = "__TogglePeacefulMode__/graphics/war.png",
    priority = "extra-high-no-scale",
    width = 32,
    height = 32,
  }
});