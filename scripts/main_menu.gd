extends Node

@onready var camera: Camera2D = $Camera2D

var current_screen = "main"
var tween

const SCREENS = {
	"main": Vector2.ZERO,
	"settings": Vector2(-320, 0),
	"credits": Vector2(0, 180)
}

func switch_screen(screen):
	print(camera.global_position)
	if SCREENS.has(screen) and screen != current_screen:
		current_screen = screen
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(camera, "global_position", SCREENS[screen], 0.4).set_trans(Tween.TRANS_QUAD)
		

func _on_settings_button_pressed() -> void:
	switch_screen("settings")

func _on_credits_button_pressed() -> void:
	switch_screen("credits")

func _on_exit_button_pressed() -> void:
	get_tree().quit() # Quit game

func _on_back_button_pressed() -> void:
	switch_screen("main")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cave.tscn")

###################
# SETTINGS SCREEN #
###################

var music_bus_id

func _on_music_slider_ready() -> void:
	# Get music audio bus id number
	music_bus_id = AudioServer.get_bus_index("Music")

func _on_music_slider_value_changed(value: float) -> void:
	# Convert linear value of slider to non-linear decibels
	var db = linear_to_db(value)

	# Tie slider position to volume in decibels
	AudioServer.set_bus_volume_db(music_bus_id, db)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
