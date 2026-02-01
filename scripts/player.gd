extends CharacterBody2D

const SPEED: float = 200.0

# UI nodes (NULL-SAFE)
@onready var mask_ui: Node = get_node_or_null("Maskbar/bar")
@onready var sus_ui: Node = get_node_or_null("TextureProgressBar")

var mask_on: bool = false
var seen_by_sight: bool = false

# Rates (tune these)
@export var mind_gain_mask_on: float = 10.0      # per second
@export var mind_recover_mask_off: float = 8.0   # per second
@export var suspicion_seen_no_mask: float = 25.0 # per second
@export var suspicion_seen_with_mask: float = 5.0

func is_mask_on() -> bool:
	return mask_on


func get_input() -> void:
	var input_direction := Input.get_vector("a", "d", "w", "s")
	velocity = input_direction * SPEED


func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()


func _process(delta: float) -> void:
	# 1) Mind control meter behavior (mask tradeoff)
	if mask_on:
		MeterSystem.add_mind(mind_gain_mask_on * delta)
	else:
		MeterSystem.add_mind(-mind_recover_mask_off * delta)

	# 2) Suspicion rises if seen
	if seen_by_sight:
		if not mask_on:
			MeterSystem.add_suspicion(suspicion_seen_no_mask * delta)
		else:
			MeterSystem.add_suspicion(suspicion_seen_with_mask * delta)

	# 3) Update UI visuals SAFELY (NO null crashes)

	if mask_ui != null:
		if mask_ui.has_method("set_filling"):
			mask_ui.call("set_filling", mask_on)
		elif "filling" in mask_ui:
			mask_ui.filling = mask_on

	if sus_ui != null:
		if "value" in sus_ui:
			sus_ui.value = MeterSystem.suspicion


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("maskOn"):
		mask_on = not mask_on


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sight"):
		seen_by_sight = true
		print("seen")


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Sight"):
		seen_by_sight = false
		print("not seen")
