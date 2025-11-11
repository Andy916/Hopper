extends Node

@onready var pause_panel := $PausePanel
@onready var background := get_parent().get_parent().get_node('Level').get_node('TextureRect')
var pause_enabled := false

func _process(_delta) -> void:
	# If you pause the game, it will freeze everything and the pause menu will appear
	if Input.is_action_just_pressed('pause') and pause_enabled:
		pause_panel.show()
		# Sets variable and calls function to set shader parameter
		background.game_paused = true
		background.pause_background()
		get_tree().paused = true


func _on_resume_pressed() -> void:
	# If the resume button is clicked, hide the pause menu and unfreeze the game
		pause_panel.hide()
		# Sets variable and calls function to set shader parameter
		background.game_paused = false
		background.pause_background()
		get_tree().paused = false

func _on_quit_pressed() -> void:
	# If the quit button is clicked, unpause the game and go back to main menu
	get_tree().paused = false
	pause_panel.hide()
	get_parent().get_parent().on_quit()
