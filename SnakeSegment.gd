extends Node2D

@onready Snake = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw() -> void:
	var tile_size = Snake.tile_size - Snake.border_size
	var start_pos = Snake.calc_tile_position(position, Snake.border_size)
	print("start_pos", start_pos)
	draw_rect(Rect2(start_pos, Vector2(tile_size, tile_size)), Color.GREEN_YELLOW)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
