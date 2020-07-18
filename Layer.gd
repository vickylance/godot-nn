extends Node
class_name Layer

var nodes: int
var activation_fn

func _init(nodes: int, activation_fn) -> void:
	self.nodes = nodes
	if (str(activation_fn) != 'Input'):
		var a = Activation.new(activation_fn)
		self.activation_fn = a.functions[activation_fn]
#		print(self.activation_fn.forward.call_func(4))

#	Layer(int nodes, String activation_fn) {
#		this.nodes = nodes;
#		if (activation_fn != 'Input') {
# Activation.functions[Activations.RELU]
#	Activation.functions[Activations.RELU].forward = func_ref()
#			this.activation_fn = ActivationFunctions[activation_fn];
