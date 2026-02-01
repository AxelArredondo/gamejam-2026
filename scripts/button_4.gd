extends Button
func _ready():
	#Button.
	text = "X"
	pressed.connect(_Button_pressed)
	position = Vector2(50, 145)
	custom_minimum_size = Vector2(30, 30)
# Called when the node enters the scene tree for the first time.
func _Button_pressed():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
