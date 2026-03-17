# MinigameOverlay.gd
extends Control

signal closed

func _ready() -> void:
	# Makes sure UI receives input
	mouse_filter = Control.MOUSE_FILTER_STOP
	$CloseButton.pressed.connect(_on_close_pressed)


func _on_close_pressed() -> void:
	closed.emit()
	queue_free()
