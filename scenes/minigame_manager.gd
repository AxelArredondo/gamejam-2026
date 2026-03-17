# MinigameManager.gd
extends Node

@export var overlay_scene: PackedScene

var _overlay: Control
var _player: Node
var _barrier: Node

func open(player: Node, barrier: Node = null) -> void:
	if _overlay != null:
		return # already open

	_player = player
	_barrier = barrier

	# freeze ONLY player movement
	if _player and "can_move" in _player:
		_player.can_move = false

	_overlay = overlay_scene.instantiate()
	get_parent().add_child(_overlay) # parent is the CanvasLayer (UI)

	_overlay.closed.connect(_on_overlay_closed)

func _on_overlay_closed() -> void:
	# unfreeze player
	if is_instance_valid(_player) and "can_move" in _player:
		_player.can_move = true

	# NOW deactivate barrier (switches animation + disables collider)
	if is_instance_valid(_barrier) and _barrier.has_method("deactivate"):
		_barrier.deactivate()

	_overlay = null
	_player = null
	_barrier = null
