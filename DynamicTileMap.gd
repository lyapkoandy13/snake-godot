@tool
extends Node2D

@export var tile_size: float = 50.0
@export var border_size: float = 2.0
@export var size: int = 10
@export var show: bool = true 

var tile_map: Array = [] # null|'apple'|'snake';

func get_random_position():
	var y = randi() % int(size);
	var x = randi() % int(size);
	return Vector2(x, y)

func calc_tile_position(position: Vector2, offset: float = 0) -> Vector2:
	var center_offset = size / 2 * tile_size

	var x = position.x * tile_size - center_offset
	var y = position.y * tile_size - center_offset
	return Vector2(x, y) + Vector2(offset, offset)

func draw_tile_borders(position: Vector2) -> void:
	draw_rect(
		Rect2(position, Vector2(tile_size, tile_size)),
		Color.DIM_GRAY,
		true
	)
	draw_rect(
		Rect2(position, Vector2(tile_size, tile_size)),
		Color.GRAY,
		false,
		2.0
	)
	
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
	if not show:
		return
		
	draw_tile_map()
	
