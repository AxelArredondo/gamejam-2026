extends Node2D

signal finished

var tags_length: int
var key_set: String
var key_number: int = 0

## This is a text box that writes out text it's given.
## Text is passed into it using a translation key that looks something like EXAMPLE. These are defined in /texts/en.csv.
## The text box will run through all the numbers associated with that key, starting at 0.
## This means it will display EXAMPLE_0, then EXAMPLE_1, then EXAMPLE_2.

func _init(key_set_to_use: String = "EXAMPLE") -> void:
	key_set = key_set_to_use

func _ready() -> void:
	show()
	set_process(true)
	write_text(tr(key_set + "_" + str(key_number)))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("AdvanceText"):
		if $Text.visible_characters == -1:
			key_number += 1
			var next_key: String = key_set + "_" + str(key_number)
			var next_text: String = tr(next_key)

			# If translation doesn't exist, end dialogue
			if next_text == next_key:
				_end_dialogue()
			else:
				write_text(next_text)
		else:
			# Skip typing, show full line instantly
			$Text.visible_characters = -1
			$CharacterDrawTimer.stop()

func write_text(text: String) -> void:
	$CharacterDrawTimer.wait_time = 1.0 / 40.0
	$Text.text = text
	$CharacterDrawTimer.start()
	$Text.visible_characters = 1
	$TextBoxSound.play()

func _on_character_draw_timer_timeout() -> void:
	$Text.visible_characters += 1
	if $Text.visible_characters % 3 != 0:
		$TextBoxSound.play()
	if $Text.visible_characters == $Text.get_parsed_text().length():
		$Text.visible_characters = -1
		$CharacterDrawTimer.stop()

func _end_dialogue() -> void:
	hide()
	set_process(false)
	finished.emit()
