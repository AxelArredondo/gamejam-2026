extends Node

signal suspicion_changed(value: float)
signal mind_changed(value: float)

var suspicion: float = 0.0
var mind: float = 0.0

var suspicion_rate: float = 0.0  # per second (used by timed increase)
var time_limit_running := false

func add_suspicion(amount: float) -> void:
	suspicion = clamp(suspicion + amount, 0.0, 100.0)
	suspicion_changed.emit(suspicion)

func set_suspicion_rate(rate: float) -> void:
	suspicion_rate = rate

func start_suspicion_timer(rate: float) -> void:
	time_limit_running = true
	suspicion_rate = rate

func stop_suspicion_timer() -> void:
	time_limit_running = false
	suspicion_rate = 0.0

func _process(delta: float) -> void:
	if time_limit_running and suspicion_rate > 0.0:
		add_suspicion(suspicion_rate * delta)
