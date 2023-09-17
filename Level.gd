extends Node2D

@export var SPEED = 1 # int =>1
@export var SIZE = 10

@export var TILE_SIZE = 50

# Speed
const BASE_SPEED_DELTA = 0.5
const SPEEDUP_STEP = 0.025


var time_elapsed = 0

# Snake / ?Controller
var current_direction: Vector2 = Vector2(0, 1)
var snake: Array[Vector2] = [Vector2(0, 0)] # [0] - head, [-1] - tail
var apples: Array[Vector2] = []

func game_over():
	get_tree().change_scene_to_file("res://UI/GameOver.tscn")

func check_collision_with_self() -> void:
	var head = snake[0] as Vector2
	for i in range(1, snake.size()):
		if head.is_equal_approx(snake[i]):
			game_over()

func check_collision_map_bounds() -> void:
	var head = snake[0]
	var new_position = head.clamp(Vector2(0, 0), Vector2($DynamicTileMap.size - 1, $DynamicTileMap.size - 1))
	var has_collided = !head.is_equal_approx(new_position)
	
	if has_collided:
		game_over()

func get_new_snake_head_position(position_delta: Vector2) -> Vector2:
	var head = snake[0]
	return head + position_delta

func move(delta: float):
	var move_delta = BASE_SPEED_DELTA - (SPEED * SPEEDUP_STEP)
	time_elapsed += delta
	var tiles_to_move = int(time_elapsed / move_delta)
	time_elapsed = time_elapsed - tiles_to_move * move_delta
	
	if tiles_to_move <= 0:
		return
	
	var position_delta = tiles_to_move * current_direction
	var new_head_position = get_new_snake_head_position(position_delta)
		
	snake.push_front(new_head_position)
		
	check_collision_map_bounds()
	check_collision_with_self()
	
	var apple_index = has_collided_with_apple()
	if apple_index != -1:
		apples.pop_at(apple_index)
		SPEED += 1
		spawn_apple()
	else:
		# pop by default
		snake.pop_back()
	
	queue_redraw()
	


func is_position_occupied_by_snake(position: Vector2) -> bool:
	for tile in snake:
		var same_position = position.is_equal_approx(tile)
		if same_position: 
			return true  
		
	return false
	
func spawn_apple() -> void:
	while true:
		var position = $DynamicTileMap.get_random_position()
		var is_occupied = is_position_occupied_by_snake(position)
		if !is_occupied: 
			apples.push_front(position)
			queue_redraw()
			return
	
func draw_snake_tile(position: Vector2) -> void:
	var start_pos = $DynamicTileMap.calc_tile_position(position)
	print("start_pos", start_pos)
	draw_rect(Rect2(start_pos, Vector2(TILE_SIZE, TILE_SIZE)), Color.GREEN_YELLOW, true, 1.0)

func draw_snake():
	for tile in snake:
		draw_snake_tile(tile)

func set_current_direction():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	
	var new_direction = null
	if direction_x:
		new_direction = Vector2(direction_x, 0)
	elif direction_y:
		new_direction = Vector2(0, direction_y)
	
	if new_direction == null:
		return
	
	# forbid opposite direction
	if snake.size() > 1:
		var head = snake[0] as Vector2
		var subhead = snake[1] as Vector2
		var delta_position = subhead - head
		if delta_position.is_equal_approx(new_direction):
			return
	
	current_direction = new_direction

func draw_apple(position: Vector2) -> void:
	var start_pos = $DynamicTileMap.calc_tile_position(position)
	draw_rect(Rect2(start_pos, Vector2(TILE_SIZE, TILE_SIZE)), Color.RED, true, 1.0)

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
	var MAP_SIZE = $DynamicTileMap.size
	var TILE_SIZE = $DynamicTileMap.tile_size

func _draw():
	draw_snake()
	draw_apples()

func _physics_process(delta):
	set_current_direction()
	move(delta)
	
