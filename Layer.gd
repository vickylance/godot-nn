extends Node
class_name Layer

var nodes: int
var activation_fn

func _init(nodes: int, activation_fn) -> void:
	self.nodes = nodes
	if (str(activation_fn) != 'Input'):
		var a = Activation.new(activation_fn)
		self.activation_fn = a.functions[activation_fn]
