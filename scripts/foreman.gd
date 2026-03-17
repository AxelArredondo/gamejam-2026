extends Node2D

@export var intro_key_set: String = "FOREMAN_INTRO"
@export var suspicion_rate_after_talk: float = 0.25  # start slow

@onready var text_box: Node = get_parent().get_node("TextBox")

var _started := false

func _ready() -> void:
	# Ensure suspicion doesn't rise until intro ends
	MeterSystem.stop_suspicion_timer()
	start_intro()

func start_intro() -> void:
	if _started:
		return
	_started = true

	# Connect once
	if not text_box.finished.is_connected(_on_intro_finished):
		text_box.finished.connect(_on_intro_finished)

	# Start dialogue
	text_box.show()
	text_box.set_process(true)
	text_box.key_set = intro_key_set
	text_box.key_number = 0
	text_box.write_text(tr(intro_key_set + "_0"))

func _on_intro_finished() -> void:
	# Stop textbox from continuing to process input
	text_box.set_process(false)
	text_box.hide()

	# Now start base suspicion slowly
	MeterSystem.start_suspicion_timer(suspicion_rate_after_talk)
