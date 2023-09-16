@tool
extends Node2D

@export var tile_size: float = 50.0 # px
@export var size: int = 10

var tile_map: Array = [] # null|'apple'|'snake';

func draw_tile_borders(position: Vector2) -> void:
	draw_rect(
		Rect2(position, Vector2(tile_size, tile_size)),
		Color.DIM_GRAY,
		true,
		2.0
	)
	draw_rect(
		Rect2(position, Vector2(tile_size, tile_size)),
		Color.GRAY,
		false,
		2.0
	)
	

func calc_tile_position(position: Vector2) -> Vector2:
	var center_offset = size / 2
	var offset = center_offset * tile_size

	var x = position.x * tile_size - offset
	var y = position.y * tile_size - offset
	return Vector2(x, y)
	
func draw_tile_map() -> void:
	for y in size:
		for x in size: 
			var pos = calc_tile_position(Vector2(x, y))
			draw_tile_borders(pos)
	

func _init() -> void:
	for y in size:
		tile_map.append([])
		for x in size: 
			tile_map[y].append(null)


func _draw() -> void:
	draw_tile_map()
	
