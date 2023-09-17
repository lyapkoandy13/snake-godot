extends Node2D

@onready var SnakeController = $SnakeController

var apples: Array[Vector2] = []

var snake: Array[Vector2] = [Vector2(0, 0)] # [0] - head, [-1] - tail

func size() -> int:
	return snake.size()

func draw_snake_tile(position: Vector2) -> void:
	var tile_size = get_parent().tile_size - get_parent().border_size
	var start_pos = get_parent().calc_tile_position(position, get_parent().border_size)
	print("start_pos", start_pos)
	draw_rect(Rect2(start_pos, Vector2(tile_size, tile_size)), Color.GREEN_YELLOW)

func draw_snake():
	for tile in snake:
		draw_snake_tile(tile)

func check_collision_with_self() -> void:
	var head = snake[0] as Vector2
	for i in range(1, snake.size()):
		if head.is_equal_approx(snake[i]):
			game_over()

func check_collision_map_bounds() -> void:
	var head = snake[0]
	var new_position = head.clamp(Vector2(0, 0), Vector2(get_parent().size - 1, get_parent().size - 1))
	var has_collided = !head.is_equal_approx(new_position)
	
	if has_collided:
		game_over()

func get_new_snake_head_position(position_delta: Vector2) -> Vector2:
	var head = snake[0]
	return head + position_delta

func move():
	var direction = SnakeController.current_direction
	var position_delta = Vector2(0, 0)
	match direction:
		SnakeController.Direction.UP:
			position_delta = Vector2(0, -1)
		SnakeController.Direction.DOWN:
			position_delta = Vector2(0, 1)
		SnakeController.Direction.LEFT:
			position_delta = Vector2(-1, 0)
		SnakeController.Direction.RIGHT:
			position_delta = Vector2(1, 0)
	
	var new_head_position = get_new_snake_head_position(position_delta)
		
	snake.push_front(new_head_position)
		
	check_collision_map_bounds()
	check_collision_with_self()
	
	var apple_index = has_collided_with_apple()
	if apple_index != -1:
		apples.pop_at(apple_index)
		#SPEED += 1
		spawn_apple()
	else:
		# pop by default
		snake.pop_back()
	
	queue_redraw()
	

func game_over():
	get_tree().change_scene_to_file("res://UI/GameOver.tscn")

func is_position_occupied_by_snake(position: Vector2) -> bool:
	for tile in snake:
		var same_position = position.is_equal_approx(tile)
		if same_position: 
			return true  
		
	return false
	
func spawn_apple() -> void:
	while true:
		var position = get_parent().get_random_position()
		var is_occupied = is_position_occupied_by_snake(position)
		if !is_occupied: 
			apples.push_front(position)
			queue_redraw()
			return

func draw_apple(position: Vector2) -> void:
	var start_pos = get_parent().calc_tile_position(position)
	var tile_size = get_parent().tile_size - get_parent().border_size
	draw_rect(Rect2(start_pos, Vector2(tile_size, tile_size)), Color.RED, true)

func draw_apples():
	for apple in apples:
		draw_apple(apple)
	
func has_collided_with_apple() -> int:
	var head = snake[0] as Vector2
	for i in range(apples.size()):
		if head.is_equal_approx(apples[i]):
			return i
	return -1
	
func _ready():
	spawn_apple()
	
func _draw():
	draw_snake()
	draw_apples()
	
