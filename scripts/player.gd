extends CharacterBody2D

const SPEED: float = 150.0

@export var music_player_path: NodePath
@export var death_sfx_path: NodePath

# UI nodes (NULL-SAFE)
@onready var mask_ui: Node = get_node_or_null("Maskbar/bar")
@onready var sus_ui: Node = get_node_or_null("TextureProgressBar")
@onready var music_player: AudioStreamPlayer = get_node_or_null(music_player_path)
@onready var death_sfx: AudioStreamPlayer2D = get_node_or_null(death_sfx_path)

var mask_on: bool = false
var seen_by_sight: bool = false
var last_direction := Vector2.DOWN
var last_input_direction := Vector2.ZERO

var can_move: bool = true
var is_dead: bool = false

# Rates (tune these)
@export var mind_gain_mask_on: float = 10.0      # per second
@export var mind_recover_mask_off: float = 8.0   # per second
@export var suspicion_seen_no_mask: float = 25.0 # per second
@export var suspicion_seen_with_mask: float = 5.0

# Flag NPCs can set when physically colliding
var collided_with_npc: bool = false

# Extra: multiplier for suspicion if NPC sees player
@export var suspicion_line_of_sight_multiplier: float = 10.0

func is_mask_on() -> bool:
	return mask_on

func die() -> void:
	if is_dead:
		return

	is_dead = true
	can_move = false
	mask_on = false
	velocity = Vector2.ZERO

	# Stop background music
	if music_player:
		music_player.stop()
	if death_sfx:
		death_sfx.play()


	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	if sprite != null and sprite.sprite_frames != null and "death" in sprite.sprite_frames.get_animation_names():
		sprite.flip_h = false
		sprite.play("death")
	else:
		push_warning("Player: 'death' animation not found on AnimatedSprite2D")


func get_input() -> void:
	var input_direction := Input.get_vector("a", "d", "w", "s")
	velocity = input_direction * SPEED

	last_input_direction = input_direction

	# Only update facing when moving
	if input_direction != Vector2.ZERO:
		last_direction = input_direction.sign()

	update_animation(input_direction)

func update_animation(input_direction: Vector2) -> void:
	# Don't override death animation
	if is_dead:
		return

	var sprite := $AnimatedSprite2D
	var moving := input_direction != Vector2.ZERO

	# Determine prefix based on mask and movement
	var base := "mask_" if mask_on else ""
	var anim_type := "walk" if moving else "idle"

	# Decide which directional animation to play
	if abs(last_direction.x) > abs(last_direction.y):
		sprite.flip_h = last_direction.x < 0
		play_anim(base + anim_type + "_side")
	else:
		sprite.flip_h = false
		if last_direction.y < 0:
			play_anim(base + anim_type + "_back")
		else:
			play_anim(base + anim_type + "_front")

func play_anim(name: String) -> void:
	if $AnimatedSprite2D.animation != name:
		$AnimatedSprite2D.play(name)

func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if can_move:
		get_input()
	else:
		velocity = Vector2.ZERO
		update_animation(Vector2.ZERO) # force idle while frozen (minigame, etc.)

	move_and_slide()

func _process(delta: float) -> void:
	# Mind control meter behavior (mask tradeoff)
	if not is_dead:
		if mask_on:
			MeterSystem.add_mind(mind_gain_mask_on * delta)
		else:
			MeterSystem.add_mind(-mind_recover_mask_off * delta)

	# If mind control is maxed out -> die
	if not is_dead and MeterSystem.mind >= MeterSystem.mind_max:
		die()

	# Update UI visuals SAFELY (NO null crashes)
	if mask_ui != null:
		if mask_ui.has_method("set_filling"):
			mask_ui.call("set_filling", mask_on)
		elif "filling" in mask_ui:
			mask_ui.filling = mask_on

	if sus_ui != null:
		if "value" in sus_ui:
			sus_ui.value = MeterSystem.suspicion

func _player_in_line_of_sight() -> bool:
	# Placeholder for now: just return if seen_by_sight
	return seen_by_sight

func _unhandled_input(event: InputEvent) -> void:
	if is_dead:
		return

	if event.is_action_pressed("mask_toggle"):
		mask_on = not mask_on
		# Use last input direction so animation updates instantly
		update_animation(last_input_direction)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sight"):
		seen_by_sight = true
		print("seen")

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Sight"):
		seen_by_sight = false
		print("not seen")
