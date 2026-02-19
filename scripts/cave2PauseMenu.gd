extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MeterSystem.start_suspicion_timer(.25) # base rate (tune this)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://scenes/Text_Menu.tscn")
	pass
