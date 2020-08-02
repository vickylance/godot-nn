extends Node2D

const ground := preload("res://src/flappy_bird/scenes/Ground/Ground.tscn")
onready var container := $Container as Node
export var ground_width := 168
const amount_to_fill_view := 2 

func _ready() -> void:
	for _i in range(amount_to_fill_view):
		spawn_and_move()
	pass


func spawn_and_move():
	spawn_ground()
	go_next_pos()


func spawn_ground():
	var new_ground = ground.instance()
	new_ground.position = position
	var err = new_ground.connect("tree_exiting", self, "spawn_and_move")
	if err != OK:
		print_debug("Error while connecting", err)
	container.call_deferred("add_child", new_ground)
	pass


func go_next_pos():
	position += Vector2(ground_width, 0)
	pass
