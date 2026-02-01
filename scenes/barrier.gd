extends StaticBody2D

func deactivate() -> void:
	# Makes it disappear and stop blocking
	visible = false
	collision_layer = 0
	collision_mask = 0


func _on_wall_switch_switched_off() -> void:
	pass # Replace with function body.
