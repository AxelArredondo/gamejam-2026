extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.





var texture_rect = TextureRect.new()
texture = load("res://icon.png")

# Anchors: left=0, top=0, right=1, bottom=1 (fills parent)
anchor_left = 0.0
anchor_top = 0.0
anchor_right = 1.0
anchor_bottom = 1.0

# Size flags: horizontal=expand, vertical=expand
size_flags_horizontal = Control.SIZE_EXPAND
size_flags_vertical = Control.SIZE_EXPAND

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
