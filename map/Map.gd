@tool
extends Node2D

@export var tile_size: float = 50.0
@export var border_size: float = 2.0
@export var size: int = 10
@export var show: bool = true 

var tile_map: Array[Array] = [] # Vector2[][]
var apples: Array[Vector2] = []

func get_random_position():
	var y = randi() % int(size);
	var x = randi() % int(size);
	return Vector2(x, y)

func calc_tile_coords(position_in_array: Vector2) -> Vector2:
	var center_offset = size / 2 * tile_size

	var x = position_in_array.x * tile_size - center_offset
	var y = position_in_array.y * tile_size - center_offset
	
	return Vector2(x, y)
	
func get_coords_for_position(position: Vector2) -> Vector2:
	return tile_map[position.x][position.y]

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
			var pos = calc_tile_coords(Vector2(x, y))
			draw_tile_borders(pos)
	

func spawn_apple() -> void:
	while true:
		var position = get_random_position()
		var is_occupied = is_position_occupied_by_snake(position)
		if !is_occupied: 
			apples.push_front(position)
			queue_redraw()
			return


func draw_apples():
	for apple in apples:
		draw_apple(apple)
	
func has_collided_with_apple() -> int:
	var head = segments[0]
	for i in range(apples.size()):
		if head.position.is_equal_approx(apples[i]):
			return i
	return -1


func _init() -> void:
	for y in size:
		tile_map.append([])
		for x in size: 
			tile_map[y].push_back(calc_tile_coords(Vector2(x, y)))


func _draw() -> void:
	if not show:
		return
		
	draw_tile_map()
	
