extends Node

@onready var camera: Camera2D = $Camera2D

var current_screen = "main"
var tween

const SCREENS = {
	"main": Vector2.ZERO,
	"settings": Vector2(-240, 0),
	"credits": Vector2(0, 160)
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

func _on_back_button_pressed() -> void:
	switch_screen("main")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		switch_screen("main")
