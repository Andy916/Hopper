extends Area2D

@onready var level = get_parent().get_parent().get_parent()

func _on_body_entered(_body) -> void:
	# Disappears and adds a point using a function from the game manager
	queue_free()
	level.add_point()
	level.collect_sound()
