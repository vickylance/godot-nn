tool
extends Node2D

var pipe = preload("res://src/flappy_bird/scenes/Pipe/Pipe.tscn")

onready var container = $Container as Node

export var pipe_width := 26.0
export var ground_height := 56.0
export var offset_y := 55.0
export var offset_x := 65.0
export var amount_to_fill_view := 1

var spawning_started := false
var first_time := false
var initial_offset := 0.0
var camera: Camera2D
var start_button: TextureButton
var next_pos := Vector2.ZERO
var prev_pos = -1


func _ready() -> void:
	camera = get_tree().root.find_node("Camera", true, false) as Camera2D
	if not camera: print_debug("Camera not found")
	
	start_button = get_tree().root.find_node("StartButton", true, false) as TextureButton
	if not start_button: print_debug("Start button not found")
	else: start_button.connect("pressed", self, "start")
	
	var ga = get_tree().root.find_node("GA", true, false) as GeneticAlgorithm
	if ga:
		print("Pipe found GA")
		ga.connect("spawned_next_gen", self, "clear_all_pipes")
	pass


func _process(_delta: float) -> void:
	if camera == null: return
	if not spawning_started: return
	
	var pipe_spacing := pipe_width + offset_x
	var screen_offset := Utils.screen_width + (pipe_width / 2)
	var start_pos = ((floor(camera.get_total_pos().x / pipe_spacing) *
			pipe_spacing) * amount_to_fill_view) + screen_offset
	
	
	if prev_pos != start_pos:
		prev_pos = start_pos
		print("Pos: ", camera.get_total_pos().x, " : ", start_pos, " : ", container.get_child_count())
		if first_time:
			initial_offset = fmod(camera.get_total_pos().x, pipe_spacing)
			first_time = false
		position = Vector2(start_pos + initial_offset, get_random_y_pos())
		for _i in range(amount_to_fill_view):
			spawn_and_move()
	pass


func start() -> void:
	print("Start spawning pipes")
	spawning_started = true
	first_time = true
	pass


func stop() -> void:
	print("Stop spawning pipes")
	spawning_started = false
	pass


func spawn_and_move() -> void:
	spawn_pipe()
	go_next_pos()
	pass


func spawn_pipe() -> void:
	var new_pipe = pipe.instance()
	new_pipe.position = position
	container.add_child(new_pipe)
	pass


func go_next_pos() -> void:
	position += Vector2((pipe_width + offset_x), 0)
	position.y = get_random_y_pos()
	pass


func get_random_y_pos() -> float:
	randomize()
	return rand_range(offset_y, Utils.screen_height - ground_height - offset_y)


func clear_all_pipes(_pop = []) -> void:
	for old_pipe in container.get_children():
		old_pipe.queue_free()
	pass

