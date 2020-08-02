extends Node

export var run_simulation := true
export var max_units := 100
export var top_units := 10
export var mutation_rate := 0.1
export(PackedScene) var agent
export(NodePath) var container

var population: Array
var generation := 0
var best_fitness := 0.0
var best_agent: Node
var best_population: Array


func _ready() -> void:
	if max_units < top_units:
		top_units = max_units
	
	if run_simulation:
		create_population()
	pass


func create_population():
	# clear any existing agents
	for old_agent in get_node(container).get_children():
		print(get_tree().get_current_scene().get_name())
		print(get_node(container).get_name())
		print("old agent", old_agent)
		old_agent.free()
	
	# create a set of agents
	for _i in range(max_units):
		var new_agent = agent.instance()
		new_agent.brain_train = true
		get_node(container).add_child(new_agent)
		population.append(new_agent)
	pass


func choose_top_population():
	pass


