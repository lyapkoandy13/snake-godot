extends Node2D

signal has_collided

const Segment = preload("res://snake/SnakeSegment.tscn")

@onready var SnakeController = get_node("Controller")
@onready var Map = get_parent()  

var apples: Array[Vector2] = []
var segments: Array[Node2D] = []

func size() -> int:
	return segments.size()

func check_collision_with_self() -> void:
	var head = segments[0].position
	for i in range(1, size()):
		if head.is_equal_approx(segments[1].position):
			emit_signal("has_collided")

func check_collision_map_bounds() -> void:
	var head = segments[0].position
	var new_position = head.clamp(Vector2(0, 0), Vector2(get_parent().size - 1, get_parent().size - 1))
	var has_collided = !head.is_equal_approx(new_position)
	
	if has_collided:
		emit_signal("has_collided")

func get_new_snake_head_position(position_delta: Vector2) -> Vector2:
	var head = segments[0]
	var position = Map.calc_tile_position(head.position + position_delta)
	return position

func add_head(position: Vector2) -> void:
	var segment = Segment.instantiate()
	segment.position = position
	add_child(segment)
	segments.push_front(segment)

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
		
	#snake.push_front(new_head_position)
		
	check_collision_map_bounds()
	check_collision_with_self()
	
	# eaten apple
	var apple_index = has_collided_with_apple()
	if apple_index != -1:
		apples.pop_at(apple_index)
		#SPEED += 1
		spawn_apple()
		add_head(new_head_position)
	else:
		segments[-1].position = new_head_position
	
	queue_redraw()
	
func is_position_occupied_by_snake(position: Vector2) -> bool:
	for segment in segments:
		var same_position = position.is_equal_approx(segment.position)
		if same_position:
			return true  
	return false
	
	
func _init():
	add_head(Vector2(0, 0))
	
