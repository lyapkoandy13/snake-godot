extends Node

@export var GameOver: PackedScene

func game_over():
	get_tree().change_scene_to_packed(GameOver)
	
func game_start():
	# spawn_apple
	pass
	
func _on_snake_has_collided():
	game_over()
