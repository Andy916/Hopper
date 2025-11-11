extends TextureRect

var game_paused := false

# Updates the paused variable in the shader editor to whatever value game_paused has
func pause_background() -> void:
	material.set_shader_parameter('paused', game_paused)
