extends StaticBody2D

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var active_anim: String = "electrified"  # plays at start
@export var inactive_anim: String = "idle"       # plays after switch

var _deactivated := false

func _ready() -> void:
	# Play the "on" animation as soon as the level starts
	if sprite != null and sprite.sprite_frames != null:
		var names := sprite.sprite_frames.get_animation_names()
		if active_anim in names:
			sprite.play(active_anim)
		else:
			push_warning("Barrier: active_anim not found: " + active_anim)

func deactivate() -> void:
	if _deactivated:
		return
	_deactivated = true

	# Stop blocking immediately
	if collider:
		collider.disabled = true
	collision_layer = 0
	collision_mask = 0

	# Switch animation to idle (off)
	if sprite != null and sprite.sprite_frames != null:
		var names := sprite.sprite_frames.get_animation_names()
		if inactive_anim in names:
			sprite.play(inactive_anim)
		else:
			push_warning("Barrier: inactive_anim not found: " + inactive_anim)
