extends Node

signal suspicion_changed(value: float)
signal mind_changed(value: float)

var suspicion: float = 0.0
var mind: float = 0.0

@export var suspicion_max: float = 100.0
@export var mind_max: float = 100.0

# time-limit / slow increase (Foreman)
var suspicion_timer_rate: float = 0.0
var suspicion_timer_running: bool = false

func add_suspicion(amount: float) -> void:
	suspicion = clamp(suspicion + amount, 0.0, suspicion_max)
	suspicion_changed.emit(suspicion)

func add_mind(amount: float) -> void:
	mind = clamp(mind + amount, 0.0, mind_max)
	mind_changed.emit(mind)

func start_suspicion_timer(rate_per_sec: float) -> void:
	suspicion_timer_rate = rate_per_sec
	suspicion_timer_running = true

func stop_suspicion_timer() -> void:
	suspicion_timer_rate = 0.0
	suspicion_timer_running = false

func _process(delta: float) -> void:
	if suspicion_timer_running and suspicion_timer_rate > 0.0:
		add_suspicion(suspicion_timer_rate * delta)
