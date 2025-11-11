extends CharacterBody2D

var SPEED := 100.0
@onready var sprite_2d := $AnimatedSprite2D
@onready var level := get_parent().get_parent().get_parent()
var gravity = ProjectSettings.get_setting('physics/2d/default_gravity')
var alive := true
var is_cliff := false
var OLDSPEED := 0.0
var alive_loops := 0

func _ready() -> void:
	# If the enemy starts turned the other way, it'll start walking the other way too
	if scale.x > 0:
		SPEED = -SPEED

func _physics_process(delta) -> void:
	# Animations
	if alive:
		if (velocity.x > 1 || velocity.x < -1):
			sprite_2d.animation = 'run'
		else:
			sprite_2d.animation = 'idle'

	# Movement
	velocity.x = SPEED

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

	# A cliff is detected when the raycast in front isn't touching anything
	# and the enemy is on the ground
	if !$RayCast2D.is_colliding() && is_on_floor():
		# Having to save the current speed into a seperate variable when making the current variable 0
		OLDSPEED = SPEED
		SPEED = 0
		is_cliff = true
		# Flip the raycast so it stops looking at the cliff while waiting
		$RayCast2D.position.x = $RayCast2D.position.x * -1
		$TurnaroundTimer.start()

func _on_walls_body_entered(_body) -> void:
	# Turn when running into a wall
	# Since the change of speed is inside the function and not the loop
	# You can set velocity to 0 instead of SPEED
	velocity.x = 0.0
	$TurnaroundTimer.start()

func _on_turnaround_timer_timeout() -> void:
	if alive:
		# If it's a cliff, flip just the sprite because the raycast was already flipped and restore old speed
		if is_cliff:
			sprite_2d.flip_h = not sprite_2d.flip_h
			SPEED = -OLDSPEED
			is_cliff = false
		# If it's a wall, just flip the whole enemy
		else:
			scale.x *= -1
			SPEED = -SPEED

func _on_player_check_body_entered(body) -> void:
	# Based on the y position of the player relative to the enemy, if it's high enough
	# The enemy will get hit, otherwise the player will
	# The player who did the hittiing or get hit will be the only one affected
	var y_delta : float = position.y - body.position.y
	if (y_delta > 15.00):
		if body.name == 'Player1':
			enemy_hit(body)
		elif body.name == 'Player2':
			enemy_hit(body)
	else:
		if body.name == 'Player1':
			body.ouch(position.x)
		elif body.name == 'Player2':
			body.ouch(position.x)



func enemy_hit(body) -> void:
	# The function of the enemy being hit
	if alive:
		body.bounce_up()
		level.add_point()
		level.hit_sound()
		set_collision_layer_value(3, false)
		$PlayerCheck.set_collision_mask_value(2, false)
		alive = false
		SPEED = 0
		sprite_2d.play('hit')
		$AliveTimer.start()

func _on_alive_timer_timeout() -> void:
	# After death animation, poof
	alive_loops += 1
	if alive_loops == 2:
		queue_free()
	sprite_2d.play('death')
	$AliveTimer.start()
