extends Node2D

@onready var timer: Timer = Timer.new()
@onready var Snake = get_parent()

const BASE_SPEED = 0.5

enum Direction { UP, DOWN, LEFT, RIGHT }

var current_direction: Direction = Direction.RIGHT

func get_opposite_direction(direction: Direction) -> Direction:
	match direction:
		Direction.UP:
			return Direction.DOWN
		Direction.DOWN:
			return Direction.UP
		Direction.LEFT:
			return Direction.RIGHT
		Direction.RIGHT:
			return Direction.LEFT
		_:
			return Direction.RIGHT 

func set_current_direction():
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	
	var new_direction = null
	if direction_x > 0:
		new_direction = Direction.RIGHT
	elif direction_x < 0:
		new_direction = Direction.LEFT
	elif direction_y > 0:
		new_direction = Direction.DOWN
	elif direction_y < 0:
		new_direction = Direction.UP
		
	if new_direction == null:
		return
		
	# forbid opposite direction
	if Snake.size() > 1:
		if get_opposite_direction(current_direction) == new_direction:
			return
	
	current_direction = new_direction

func _on_timer_timeout():
	print("Timeout - moving snake")
	Snake.move()

func _ready():
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start(BASE_SPEED)

func _input(event):
	set_current_direction()
	
func _exit_tree():
	timer.queue_free()
