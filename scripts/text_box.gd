extends Node2D
var tags_length: int
var key_set: String
var key_number = 0

## This is a text box that writes out text it's given.
## Text is passed into it using a translation key that looks something like EXAMPLE. These are defined in /texts/en.csv.
## The text box will run through all the numbers associated with that key, starting at 0.
## This means it will display EXAMPLE_0, then EXAMPLE_1, then EXAMPLE_2.

func _init(key_set_to_use = "EXAMPLE") -> void:
	key_set = key_set_to_use

func _ready() -> void:
	write_text(tr(key_set + "_" + str(key_number)))

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("AdvanceText"):
		if $Text.visible_characters == -1:
			key_number += 1
			if tr(key_set + "_" + str(key_number)) == key_set + "_" + str(key_number):
				pass
			else:
				write_text(tr(key_set + "_" + str(key_number)))
		else:
			pass
			$Text.visible_characters = -1
			$CharacterDrawTimer.stop()

func write_text(text: String) -> void:
	
	## Writes a piece of text to the text box over time.
	## String text: the string to write.
	
	$CharacterDrawTimer.wait_time = 1.0 / 40
	$Text.text = text
	print("set text to " + text)
	$CharacterDrawTimer.start()
	$Text.visible_characters = 1
	$TextBoxSound.play()

func _on_character_draw_timer_timeout() -> void:
	$Text.visible_characters += 1
	if $Text.visible_characters % 3:
		$TextBoxSound.play()
	if $Text.visible_characters == $Text.get_parsed_text().length():
		$Text.visible_characters = -1
		print("visible characters set to -1")
		$CharacterDrawTimer.stop()
