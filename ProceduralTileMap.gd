extends Node2D

class_name ProceduralTileMap

@export var size = 10
@export var tile_size = 50.0 # px

var tile_map = Array() # null|'apple'|'snake';

func calc_tile_center_position(position: Vector2i) -> Vector2:
	var middle_offset = size / 2
	var x = (position.x - middle_offset) * tile_size - tile_size / 2
	var y = (position.y - middle_offset) * tile_size - tile_size / 2
	return Vector2(x, y)

func _draw_tile_borders(center_vector: Vector2) -> void:
	draw_rect(
		Rect2(center_vector, Vector2(size, size)),
		Color.WHITE,
		false,
		1.0
	)

func _draw_tile(position: Vector2) -> void:
	var center_position = calc_tile_center_position(position)
	_draw_tile_borders(center_position)

# Overrides

func _init():
	for y in size:
		tile_map.append([])
		for x in size: 
			tile_map[y].append(null)

func _draw():
	for y in size:
		for x in size: 
			_draw_tile(Vector2(x, y))
