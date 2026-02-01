extends TextureProgressBar
var filling = false
var fill_speed = 1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if filling == true:
		value += fill_speed
		print(value)
	else:
		value -= fill_speed
