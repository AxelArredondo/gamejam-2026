extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var text_box1 = RichTextLabel.new()
	text_box1.text = "
	Credits
	 



	
Game Design/programming
Axel Arredondo
Rain Vasquez
Taran Hurley
Alex Morosov Ilnytsky
Rain Vaquez
Connor Bosco
Autum Darell
Mae Moon

Art
Camille Tsui
Jordi Usen
Alma
Lemon

Music & Sound
Autum Darrell
Tim Rivero
Jordan Parm
	"
	text_box1.bbcode_enabled = true # Enable BBCode for rich formatting
	text_box1.custom_minimum_size = Vector2(110, 300) # Set minimum size
	add_child(text_box1)
	text_box1.position = Vector2(120, 10)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://scenes/Text_Menu.tscn")
	pass
