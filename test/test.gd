@tool
extends Node2D

const DrawTest = preload("draw_test.tscn")

const amount = 5

var nodes = []

func _init():
	for i in range(amount):
		var node = DrawTest.instantiate()
		node.position = Vector2(i * 75, i * 75)
		add_child(node)
		nodes.push_back(node)
		
	var node = nodes.pop_back()
	node.queue_free()
	
