extends Node2D

@export var intro_key_set: String = "FOREMAN_INTRO"
@export var suspicion_rate_after_talk: float = 3.0


@onready var text_box: Node = get_parent().get_node("TextBox")

func _ready() -> void:
	start_intro()

func start_intro() -> void:
	# Connect once
	if not text_box.finished.is_connected(_on_intro_finished):
		text_box.finished.connect(_on_intro_finished)

	# Start dialogue immediately
	text_box.show()
	text_box.set_process(true)
	text_box.key_set = intro_key_set
	text_box.key_number = 0
	text_box.write_text(tr(intro_key_set + "_0"))

func _on_intro_finished() -> void:
	# Start time limit (slow suspicion rise)
	MeterSystem.start_suspicion_timer(suspicion_rate_after_talk)
