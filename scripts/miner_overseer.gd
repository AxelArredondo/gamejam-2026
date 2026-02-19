extends Node2D

@export var turn_interval := 1.5
@export var suspicion_on_wrong := 15.0

@onready var vision: VisionSensor = $VisionSensor
@onready var timer: Timer = $TurnTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var dirs := [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
var dir_i := 0
var _asking := false

func _ready() -> void:
	timer.wait_time = turn_interval
	timer.timeout.connect(_turn_clockwise)
	timer.start()

	vision.player_seen.connect(_on_player_seen)
	_apply_facing(dirs[dir_i])

func _turn_clockwise() -> void:
	dir_i = (dir_i + 1) % dirs.size()
	_apply_facing(dirs[dir_i])

func _apply_facing(dir: Vector2) -> void:
	# rotate the vision cone area to match direction
	if dir == Vector2.RIGHT:  vision.rotation_degrees = 0
	if dir == Vector2.DOWN:   vision.rotation_degrees = 90
	if dir == Vector2.LEFT:   vision.rotation_degrees = 180
	if dir == Vector2.UP:     vision.rotation_degrees = 270

	
	if dir == Vector2.LEFT:
		sprite.play("idle_side")
		sprite.flip_h = true
	elif dir == Vector2.RIGHT:
		sprite.play("idle_side")
		sprite.flip_h = false
	elif dir == Vector2.UP:
		sprite.play("idle_up")
		sprite.flip_h = false
	elif dir == Vector2.DOWN:
		sprite.play("idle_down")
		sprite.flip_h = false

func _on_player_seen(player: Node) -> void:
	if _asking:
		return
	_asking = true
	timer.stop()

	# Call dialogue/question UI here.
	# You need a function that returns correct/incorrect via callback/signal.
	DialogueManager.ask_question(
		"TURN_GUARD_Q1",
		func(correct: bool) -> void:
			if not correct:
				MeterSystem.add_suspicion(suspicion_on_wrong)
			_asking = false
			timer.start()
	)
