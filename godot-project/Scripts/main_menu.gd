extends Node
@onready var oneplayer := $'1Player'
@onready var twoplayers := $'2Players'
@onready var controls := $Controls
@onready var controls_menu := $ControlsMenu
signal level_changed(level_name, fell)
@export var level_name : String

var level_parameters := {
	'points': 0, 'players': 0, 'player1_health': 3, 'player2_health': 3
	}

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	oneplayer.show()
	await get_tree().create_timer(1.0).timeout
	if is_instance_valid(twoplayers):
		twoplayers.show()
	await get_tree().create_timer(1.0).timeout
	if is_instance_valid(controls):
		controls.show()

func _on_1_player_pressed() -> void:
	# If singleplayer is selected
	oneplayer.queue_free()
	twoplayers.queue_free()
	level_parameters.players = 1
	level_changed.emit(level_name, false)

func _on_2_players_pressed() -> void:
	# If multiplayer is selected
	oneplayer.queue_free()
	twoplayers.queue_free()
	level_parameters.players = 2
	level_changed.emit(level_name, false)

func _on_controls_pressed() -> void:
	controls_menu.show()

func _on_controls_close_pressed() -> void:
	controls_menu.hide()
