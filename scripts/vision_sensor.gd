extends Area2D
class_name VisionSensor

signal player_seen(player: Node)
signal player_lost(player: Node)

@export var require_line_of_sight := true
@export var ray_mask: int = 1  

var _player_in_area: Node = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(_delta: float) -> void:
	if _player_in_area == null:
		return

	if require_line_of_sight and not _has_los(_player_in_area):
		# player is inside cone but behind a wall
		player_lost.emit(_player_in_area)
		return

	player_seen.emit(_player_in_area)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_in_area = body

func _on_body_exited(body: Node) -> void:
	if body == _player_in_area:
		player_lost.emit(body)
		_player_in_area = null

func _has_los(player: Node) -> bool:
	# Raycast from guard to player; if it hits a wall first, no LOS
	var space := get_world_2d().direct_space_state
	var from := global_position
	var to := (player as Node2D).global_position
	var query := PhysicsRayQueryParameters2D.create(from, to)
	query.collision_mask = ray_mask
	query.exclude = [self, player]  # exclude player so ray only hits walls
	var hit := space.intersect_ray(query)
	return hit.is_empty()

@export var mask_on := false

func set_mask(on: bool) -> void:
	mask_on = on
