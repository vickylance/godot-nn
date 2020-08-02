extends Node
class_name Layer

var nodes: int
var activation_fn

func _init(init_nodes: int, init_activation_fn) -> void:
	self.nodes = init_nodes
	if (str(init_activation_fn) != 'Input'):
		var a = Activation.new(init_activation_fn)
		self.activation_fn = a.functions[init_activation_fn]
