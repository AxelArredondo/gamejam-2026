extends Node2D

signal switched_off

@export var interact_action: StringName = &"interact"

# Drag this in the inspector to your UI/MinigameManager
@export var minigame_manager_path: NodePath

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var trigger: Area2D = $Area2D

var _player_in_range: bool = false
var _player_ref: Node = null
var is_on: bool = true
var _busy: bool = false

func _ready() -> void:
	# Start on pose
	if _has_anim("idle_on"):
		sprite.play("idle_on")

	trigger.monitoring = true
	trigger.monitorable = true

func _process(_delta: float) -> void:
	# Manual interact only (no auto trigger)
	if _player_in_range and is_on and not _busy and Input.is_action_just_pressed(interact_action):
		_open_minigame()

# --- RANGE DETECTION ---

func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		_player_ref = body

func _on_area_2d_body_exited(body: Node) -> void:
	if body == _player_ref:
		_player_in_range = false
		_player_ref = null

func _on_area_2d_area_entered(area: Area2D) -> void:
	# If your player uses an Area2D to detect, this supports that too
	if area.is_in_group("player"):
		_player_in_range = true
		_player_ref = area.get_parent() if area.get_parent() != null else area

func _on_area_2d_area_exited(area: Area2D) -> void:
	if _player_ref == area or _player_ref == area.get_parent():
		_player_in_range = false
		_player_ref = null

# --- MINIGAME FLOW ---

func _open_minigame() -> void:
	if _busy or not is_on:
		return
	_busy = true

	var mgr = get_node_or_null(minigame_manager_path)
	if mgr == null:
		push_warning("Switch: MinigameManager path not set / not found.")
		_busy = false
		return

	# Open overlay. Player freezes only; world keeps running.
	# We pass *this switch* as the "barrier-like target" and let the manager call our complete method.
	# (We’ll implement complete_switch_off() below.)
	if mgr.has_method("open"):
		mgr.open(_player_ref, self)
	else:
		push_warning("Switch: MinigameManager has no open(player, target) method.")
		_busy = false
		return

# This gets called AFTER the overlay is closed (by the manager).
# Name it "deactivate" so it plugs into the manager you already made earlier.
func deactivate() -> void:
	# If already off, ignore
	if not is_on:
		_busy = false
		return

	await _turn_off_animations_and_emit()

func _turn_off_animations_and_emit() -> void:
	print("Switch: turning off AFTER minigame")

	# Play flip animation if it exists
	if _has_anim("flip_off"):
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
