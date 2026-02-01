extends TextureProgressBar
@export var PlayerColliding = false
var fill_speed 
var paused = false
#value is drastic to see the changes happening

var startFilling = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = 0
	startFilling = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if paused == false and startFilling == true:
		fill_speed = 1
		value += fill_speed
	if PlayerColliding == true:
		#adjust this value to increase suspicion gained while in collsion cone (this is an instant burst of gain instead of gradual)
		fill_speed = 10
		value += fill_speed
		print("in collision")
	elif PlayerColliding == false :
		fill_speed = 1
		print(fill_speed)
