extends Node2D

onready var container := $Container as Node

const ground := preload("res://src/flappy_bird/scenes/Ground/Ground.tscn")
const amount_to_fill_view := 2

var ground_width: float
var camera: Camera2D
var prev_pos = -1
var spawning_started := false


func _ready() -> void:
	camera = get_tree().root.find_node("Camera", true, false) as Camera2D
	var temp_ground = ground.instance()
	var ground_sprite = find_by_sprite(temp_ground)
	if ground_sprite:
		ground_width = ground_sprite.texture.get_size().x
		start()
	else:
		print_debug("Could not find the ground sprite width")
	pass


func _process(_delta: float) -> void:
	if camera == null: return
	if not spawning_started: return
	
	var start_pos = (floor(camera.get_total_pos().x / ground_width) *
			ground_width)
	
	if prev_pos != start_pos:
#		print("Pos: ", camera.get_total_pos().x, " : ", start_pos, " : ", container.get_child_count())
		prev_pos = start_pos
		position = Vector2(start_pos, position.y)
		for _i in range(amount_to_fill_view):
			spawn_and_move()
	pass


func start() -> void:
	spawning_started = true
	pass


func stop() -> void:
	spawning_started = false
	pass


func spawn_and_move():
	spawn_ground()
	go_next_pos()
	pass


func spawn_ground():
	var new_ground = ground.instance()
	new_ground.position = position
	container.add_child(new_ground)
	pass


func go_next_pos():
	position += Vector2(ground_width, 0)
	pass


func find_by_sprite(parent: Node) -> Sprite:
	for child in parent.get_children():
		if child is Sprite:
			return child
		else:
			var result: Sprite = find_by_sprite(child)
			if result:
				return result
	return null
