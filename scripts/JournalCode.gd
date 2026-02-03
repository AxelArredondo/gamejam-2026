extends TextEdit

var journal_path := "res://journal.txt"


func _ready() -> void:
	editable = true
	size = Vector2(280, 140)
	position = Vector2(20, 30)
	text = "Write your journal here...then press ESC"
	open_journal()
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.908, 0.894, 0.807, 0.196)  # RGBA: white with 50% transparency
	#style_box.border_width_all = 1
	style_box.border_color = Color(1,1,1,0.8)
	
	# Apply the style override to the TextEdit
	add_theme_stylebox_override("normal", style_box)

# Create a new Color for black
	var black_color = Color(0, 0, 0)

# Override the theme for this TextEdit
	add_theme_color_override("font_color", black_color)

func save_journal():
	var file = FileAccess.open(journal_path, FileAccess.WRITE)  # Updated API
	if file:
		file.store_string(text)
		file.close()
		print("Journal saved successfully at ", journal_path)
	else:
		print("Error: Cannot open file for writing.")

# Load the content from the file into TextEdit
func open_journal():
	if FileAccess.file_exists(journal_path):
		var file = FileAccess.open(journal_path, FileAccess.READ)  # Updated API
		if file:
			text = file.get_as_text()
			file.close()
			print("Journal loaded successfully.")
		else:
			print("Error: Cannot open file for reading.")
	else:
		text = "Write your journal here...then press ESC"  # Clear TextEdit if no file exists
		print("No journal file found, starting fresh.")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		save_journal()
		get_tree().change_scene_to_file("res://scenes/Text_Menu.tscn")

	pass
