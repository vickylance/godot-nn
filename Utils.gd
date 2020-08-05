extends Node

var screen_height: float
var screen_width: float
var GA: GeneticAlgorithm

func _ready() -> void:
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y
	pass

func _process(_delta: float) -> void:
	if GA == null:
		GA = get_tree().root.find_node("GA", true, false) as GeneticAlgorithm
	pass

func map(x: float, in_min: float, in_max: float, out_min: float, out_max: float):
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

var previous_gaussian = false
var y2: float = 0
func random_gaussian(mean: float, sd: float):
	var y1: float
	var x1: float
	var x2: float
	var w: float
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	if previous_gaussian:
		y1 = y2
		previous_gaussian = false
	else:
		while true:
			x1 = rng.randf_range(0, 1)
			x2 = rng.randf_range(0, 1)
			w = x1 * x1 + x2 * x2
			if w < 1:
				break
		w = sqrt(-2 * log(w) / w)
		y1 = x1 * w
		y2 = x2 * w
		previous_gaussian = true
	var m: float = mean or 0
	var s: float = sd or 1
	return y1 * s + m
	pass


func find_by_type_name(parent: Node, type_name: String) -> Node:
	for child in parent.get_children():
		if child.has_method("get_class") and child.get_class() == type_name:
			return child
		else:
			var result: Node = find_by_type_name(child, type_name)
			if result:
				return result
	return null
