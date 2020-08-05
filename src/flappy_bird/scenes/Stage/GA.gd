extends Node
class_name GeneticAlgorithm

signal spawned_next_gen(population)

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
	if !run_simulation: return
	
	if max_units < top_units:
		top_units = max_units
	
	create_population()
	var err = Game.connect("all_birds_grounded", self, "spawn_next_generation")
	if err != OK:
		print_debug("Error connecting to all_birds_grounded")
	pass


func create_population():
	# create a set of agents
	population = []
	for _i in range(max_units):
		var new_agent = agent.instance()
		new_agent.brain_train = true
		if best_agent != null:
			new_agent.brain = best_agent.brain.clone()
			new_agent.brain.mutate(0.05)
		population.append(new_agent)
	
	# clear any existing agents
	for old_agent in get_node(container).get_children():
		old_agent.free()
	
	# append the new agents to the container
	for new_agent in population:
		get_node(container).add_child(new_agent)
	pass


func choose_top_population():
	pass


func pick_top_most():
	# find the highest fitness entity
	var top_fitness = 0
	for saved_agent in population:
		if saved_agent.fitness > top_fitness:
			top_fitness = saved_agent.fitness
			best_agent = saved_agent
	
#	print("Best fitness: ", best_agent.fitness)
	pass


func spawn_next_generation(state) -> void:
	print("Spawn next generation")
	if state == true:
		pick_top_most()
		create_population()
		emit_signal("spawned_next_gen", population)
	pass


