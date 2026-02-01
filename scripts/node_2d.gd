#Character script 
extends CharacterBody2D
@onready var mask = $Maskbar/bar
@onready var sus = $TextureProgressBar
var in_collision = 1000
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
	sus._process(delta)
	sus.PlayerColliding = false
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("maskOn"):
		mask.filling  = not mask.filling
func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("Sight"):
		sus.PlayerColliding = true
		print("colliding Other")		
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Sight"):
		sus.PlayerColliding = false
		print("no longer colliding")

		
