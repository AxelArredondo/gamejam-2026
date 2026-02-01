extends CharacterBody2D
@onready var mask = $Maskbar/bar
var pressed = false
const SPEED = 300.0

func get_input():
	var input_direction = Input.get_vector("a","d","w","s")
	velocity = input_direction * SPEED
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
func _process(delta: float) -> void:
	if mask.filling == true:
		mask._process(delta)
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("maskOn"):
		mask.filling  = not mask.filling
		
