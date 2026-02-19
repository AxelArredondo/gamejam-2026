extends CanvasLayer

@onready var mind_bar: TextureProgressBar = get_node_or_null("Bars/MindBar") as TextureProgressBar
@onready var suspicion_bar: TextureProgressBar = get_node_or_null("Bars/SuspicionBar") as TextureProgressBar

func _ready() -> void:
	# Debug: tell you exactly what's missing
	if mind_bar == null:
		push_warning("HUD: Could not find Bars/MindBar under HUD. Check node names/paths.")
	if suspicion_bar == null:
		push_warning("HUD: Could not find Bars/SuspicionBar under HUD. Check node names/paths.")

	# Only run if they exist
	if mind_bar != null:
		mind_bar.min_value = 0
		mind_bar.max_value = 100
		mind_bar.value = MeterSystem.mind

	if suspicion_bar != null:
		suspicion_bar.min_value = 0
		suspicion_bar.max_value = 100
		suspicion_bar.value = MeterSystem.suspicion

	# Connect signals (only if bars exist)
	if mind_bar != null and not MeterSystem.mind_changed.is_connected(_on_mind_changed):
		MeterSystem.mind_changed.connect(_on_mind_changed)

	if suspicion_bar != null and not MeterSystem.suspicion_changed.is_connected(_on_suspicion_changed):
		MeterSystem.suspicion_changed.connect(_on_suspicion_changed)

func _on_mind_changed(value: float) -> void:
	if mind_bar != null:
		mind_bar.value = value

func _on_suspicion_changed(value: float) -> void:
	if suspicion_bar != null:
		suspicion_bar.value = value
