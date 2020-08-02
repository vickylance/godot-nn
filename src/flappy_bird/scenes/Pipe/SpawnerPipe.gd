# script: SpawnerPipe.gd

extends Node2D

var pipe = preload("res://src/flappy_bird/scenes/Pipe/Pipe.tscn")
onready var container = $Container as Node
export var pipe_width := 26.0
export var ground_height := 56.0
export var offset_y := 55.0
export var offset_x = 65.0
export var amount_to_fill_view := 3

var spawning_started := false

func _process(_delta: float) -> void:
	if spawning_started: return
	
	var bird = Game.bird as Bird
	print("bird connecting pipe", bird)
	var err = bird.connect("state_changed", self, "_on_bird_state_changed", [], CONNECT_ONESHOT)
	if err != OK:
		print_debug("Error while connecting", err)
	else:
		spawning_started = true
	pass


func _on_bird_state_changed(bird):
	if bird.get_state() == bird.States.FLAPPING:
		start()
	pass


func start() -> void:
	go_init_pos()
	for _i in range(amount_to_fill_view):
		spawn_and_move()
	pass


func go_init_pos() -> void:
	randomize()
	
	var init_pos = Vector2.ZERO
	init_pos.x = float(get_viewport_rect().size.x + pipe_width / 2)
	init_pos.y = rand_range(offset_y,
			get_viewport_rect().size.y - ground_height - offset_y)
	
	var camera = get_tree().root.find_node("Camera", true, false) as Camera2D
	if camera:
		init_pos.x += camera.get_total_pos().x
	
	position = init_pos
	pass


func spawn_and_move() -> void:
	spawn_pipe()
	go_next_pos()
	pass


func spawn_pipe() -> void:
	var new_pipe = pipe.instance()
	new_pipe.position = position
	var err = new_pipe.connect("tree_exiting", self, "spawn_and_move")
	if err != OK:
		print_debug("Error while connecting", err)
	container.call_deferred("add_child", new_pipe)
	pass


func go_next_pos() -> void:
	randomize()
	
	var next_pos = position
	next_pos.x += float(pipe_width / 2 + offset_x + pipe_width / 2)
	next_pos.y = rand_range(offset_y,
			get_viewport_rect().size.y - ground_height - offset_y)
	position = next_pos
	pass

