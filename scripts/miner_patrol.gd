extends CharacterBody2D

@export var speed: float = 50.0
@export var loop: bool = true

@export var suspicion_rate_mask_off: float = 25.0
@export var suspicion_rate_mask_on: float = 5.0
@export var add_suspicion_when_mask_on: bool = false

@export var patrol_path: NodePath 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var vision: VisionSensor = $VisionSensor

var _seeing_player: bool = false
var _player_ref: Node = null

var _path: Path2D
var _t: float = 0.0

func _ready() -> void:
	vision.player_seen.connect(_on_player_seen)
	vision.player_lost.connect(_on_player_lost)

	if patrol_path != NodePath():
		_path = get_node(patrol_path) as Path2D
	else:
		push_error("MinerPatrol: patrol_path not assigned!")

func _physics_process(delta: float) -> void:
	_patrol_along_path(delta)
	_apply_suspicion(delta)

func _patrol_along_path(delta: float) -> void:
	if _path == null or _path.curve == null or _path.curve.point_count < 2:
		return

	# Move along curve by distance
	_t += speed * delta
	var length := _path.curve.get_baked_length()
	if loop:
		_t = fmod(_t, length)
	else:
		_t = min(_t, length)

	var target := _path.to_global(_path.curve.sample_baked(_t))
	var dir := (target - global_position)

	if dir.length() > 0.001:
		velocity = dir.normalized() * speed
		move_and_slide()
		_face_direction(velocity)

func _face_direction(v: Vector2) -> void:
	if abs(v.x) > abs(v.y):
		vision.rotation_degrees = 0 if v.x > 0 else 180
		sprite.flip_h = v.x < 0
		sprite.play("walk_side")
	else:
		vision.rotation_degrees = 90 if v.y > 0 else 270
		sprite.play("walk_side") 

@export var seen_multiplier: float = 2.0  # "seen" makes it ~2x faster than normal

@export var extra_suspicion_when_seen_unmasked: float = 6.0 # extra per second

func _apply_suspicion(delta: float) -> void:
	if not _seeing_player or _player_ref == null:
		return

	# Check mask state from player
	var mask_on := false
	if _player_ref.has_method("is_mask_on"):
		mask_on = _player_ref.call("is_mask_on") as bool
	elif "mask_on" in _player_ref:
		mask_on = bool(_player_ref.mask_on)

	# If masked, do NOT increase rate (stay at base timer only)
	if mask_on:
		return

	# If unmasked and seen, add extra suspicion (on top of base timer)
	MeterSystem.add_suspicion(extra_suspicion_when_seen_unmasked * delta)


func _on_player_seen(player: Node) -> void:
	_seeing_player = true
	_player_ref = player

func _on_player_lost(_player: Node) -> void:
	_seeing_player = false
	_player_ref = null
