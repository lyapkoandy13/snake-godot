@tool
extends Node2D

@export var size: float = 50.0
@export_color_no_alpha var color = Color.AQUAMARINE

func _draw() -> void:
	draw_rect(Rect2(0, 0, size, size), color)
