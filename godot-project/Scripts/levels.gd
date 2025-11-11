extends Node
signal level_changed(level_name, fell)

@onready var player1 := $Players/Player1
@onready var player2 := $Players/Player2
@onready var player1_healthbar := $UI/Health/HealthBars/Player1Health
@onready var player2_healthbar := $UI/Health/HealthBars/Player2Health
@export var level_name : String
# Store level parameters
var level_parameters := {
	'points': 0, 'players': 0, 'player1_health': 3, 'player2_health': 3
	}

# Called from scene_manager, transfers data from old level to current level and updates things
func load_level_parameters(old_level_parameters: Dictionary) -> void:
	level_parameters = old_level_parameters
	$UI/Points/PointsLabel.text = 'POINTS: ' + str(level_parameters.points)

func _ready() -> void:
	# Updates more things
	if level_parameters.players == 1:
		player2_healthbar.hide()
		player2.queue_free()
	if level_parameters.player1_health == 0:
		player2.camera_transfer()
		player1_healthbar.hide()
		player1.queue_free()
	if level_parameters.player2_health == 0:
		player2_healthbar.hide()
		player2.queue_free()
	# Updates healthbars based on each player's health from previous levels
	match level_parameters.player1_health:
		2:
			player1_healthbar.get_node('Health3').hide()
		1:
			player1_healthbar.get_node('Health3').hide()
			player1_healthbar.get_node('Health2').hide()
		_:
			pass
	match level_parameters.player2_health:
		2:
			player2_healthbar.get_node('Health3').hide()
		1:
			player2_healthbar.get_node('Health3').hide()
			player2_healthbar.get_node('Health2').hide()
		_:
			pass

func add_point() -> void:
	# Adds a point and updates the UI points display
	level_parameters.points += 1
	$UI/Points/PointsLabel.text = 'POINTS: ' + str(level_parameters.points)

func collect_sound() -> void:
	$Sounds/Collect.play()

func jump_sound() -> void:
	$Sounds/Jump.play()

func hit_sound() -> void:
	$Sounds/Hit.play()

func get_hit_sound() -> void:
	$Sounds/GetHit.play()

func dash_sound() -> void:
	$Sounds/Dash.play()

func _on_finish_body_entered(body) -> void:
	# If a player enters the trohpy, go to the next level
	if body.name == 'Player1' or body.name == 'Player2':
		level_changed.emit(level_name, false)

func on_fall() -> void:
	# Transitions to the same level the players are in if they both fall
	level_parameters.points = 0
	level_changed.emit(level_name, true)

func on_quit() -> void:
	# Called by player and pause scripts, changes level if the players fall or quits the game
	level_name = 'quit'
	level_changed.emit(level_name, false)
