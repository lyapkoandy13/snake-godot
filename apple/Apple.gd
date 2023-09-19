extends Node2D

@export var size: float = 50.0
@export_color_no_alpha var color = Color.RED

func _draw() -> void:
	draw_rect(Rect2(position, Vector2(size, size)), color, true)

