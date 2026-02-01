extends Node2D
var Selection: int=1 #global variable


var Arrow = RichTextLabel.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var text_box1 = RichTextLabel.new()
	text_box1.text = "Settings"
	text_box1.bbcode_enabled = true # Enable BBCode for rich formatting
	text_box1.custom_minimum_size = Vector2(100, 50) # Set minimum size
	add_child(text_box1)
	text_box1.position = Vector2(100, 10)
	
	var text_box2 = RichTextLabel.new()
	text_box2.text = "Journal"
	text_box2.bbcode_enabled = true # Enable BBCode for rich formatting
	text_box2.custom_minimum_size = Vector2(100, 50) # Set minimum size
	add_child(text_box2)
	text_box2.position = Vector2(100, 60)
	
	var text_box3 = RichTextLabel.new()
	text_box3.text = "Credits"
	text_box3.bbcode_enabled = true # Enable BBCode for rich formatting
	text_box3.custom_minimum_size = Vector2(100, 50) # Set minimum size
	add_child(text_box3)
	text_box3.position = Vector2(100, 110)
	
	var text_box4 = RichTextLabel.new()
	text_box4.text = "Exit Game"
	text_box4.bbcode_enabled = true # Enable BBCode for rich formatting
	text_box4.custom_minimum_size = Vector2(100, 50) # Set minimum size
	add_child(text_box4)
	text_box4.position = Vector2(100, 160)
	
	
	Arrow.text = " <=="
	Arrow.bbcode_enabled = true # Enable BBCode for rich formatting
	Arrow.custom_minimum_size = Vector2(100, 20) # Set minimum size
	add_child(Arrow)
	Arrow.position = Vector2(175, 20)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	print(direction)
	
	#if Input.is_action_just_pressed("Right"):
		#$Icon.position += Vector2(1,0) * 50 * delta
	#if Input.is_action_just_pressed("Left"):
		#$Icon.position += Vector2(-1,0) * 50 * delta	
	if Input.is_action_just_pressed("Up"):
		Selection += -1
		if Selection == 0:
			Selection = 4
		#$Icon.position += Vector2(0,-1) * 50 * delta
	if Input.is_action_just_pressed("Down"):
		Selection += +1
		if Selection == 5:
			Selection = 1
		#$Icon.position += Vector2(0,1) * 50 * delta	

	Arrow.position = Vector2(175, 10+50*Selection-50)

	if Input.is_action_just_pressed("Enter"):
		if Selection == 1:
			get_tree().change_scene_to_file("res://scenes/Settings_Scene.tscn")
		if Selection == 2:
			get_tree().change_scene_to_file("res://scenes/Journal_Scene.tscn")
		if Selection == 3:
			get_tree().change_scene_to_file("res://scenes/Credits_Scene.tscn")
		if Selection == 4:
			get_tree().quit()
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://scenes/cave.tscn")
	pass
