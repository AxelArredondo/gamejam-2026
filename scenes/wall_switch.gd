extends Node2D

signal switched_off

@export var auto_trigger: bool = true
@export var interact_action: StringName = &"interact"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var trigger: Area2D = $Area2D

var _player_in_range: bool = false
var is_on: bool = true
var _busy: bool = false

func _ready() -> void:
	# Debug: confirm animations exist
	if sprite.sprite_frames != null:
		print("Switch animations:", sprite.sprite_frames.get_animation_names())

	# Start on pose
	if _has_anim("idle_on"):
		sprite.play("idle_on")

	# Make sure Area2D is active
	trigger.monitoring = true
	trigger.monitorable = true

func _process(_delta: float) -> void:
	if not auto_trigger and _player_in_range and is_on and Input.is_action_just_pressed(interact_action):
		turn_off()

# --- SIGNAL HANDLERS (connect these!) ---

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("Switch: player body entered")
		_player_in_range = true
		if auto_trigger and is_on:
			turn_off()

func _on_area_2d_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		print("Switch: player body exited")
		_player_in_range = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	# If your player uses an Area2D, it might be this one entering
	if area.is_in_group("player"):
		print("Switch: player area entered")
		_player_in_range = true
		if auto_trigger and is_on:
			turn_off()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("Switch: player area exited")
		_player_in_range = false

# --- ACTION ---

func turn_off() -> void:
	if not is_on or _busy:
		return
	_busy = true

	print("Switch: turning off")

	# Play flip animation if it exists
	if _has_anim("flip_off"):
		# Make sure flip_off is NOT looping in SpriteFrames
		sprite.play("flip_off")
		await sprite.animation_finished

	is_on = false
	_busy = false

	# Final off pose
	if _has_anim("idle_off"):
		sprite.play("idle_off")

	switched_off.emit()

func _has_anim(name: String) -> bool:
	return sprite.sprite_frames != null and name in sprite.sprite_frames.get_animation_names()


func _on_switched_off() -> void:
	pass # Replace with function body.
