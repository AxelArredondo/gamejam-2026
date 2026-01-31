extends Node2D
var text_length: int
var tags_length: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	write_text("This is a piece of example text that will be typed out over time by the write_text() method. It takes up multiple lines and will be scrolled through accordingly.", "[shake rate=15 level=5]")


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func write_text(text: String, tags = "", speed = 30):
	
	## Writes a piece of text to the text box over time.
	## String text: the string to write.
	## String tags: a string of bbcode tags to apply to the text, defaults to empty string.
	## float speed: the speed to write in characters per second, defaults to 30.
	
	text_length = text.length()
	tags_length = tags.length()
	$CharacterDrawTimer.wait_time = 1.0 / speed
	$Text.text = tags + text
	$CharacterDrawTimer.start()
	$Text.visible_characters = tags_length + 1

func _on_character_draw_timer_timeout() -> void:
	$Text.visible_characters += 1
	if $Text.visible_characters == text_length + tags_length:
		$CharacterDrawTimer.stop()
