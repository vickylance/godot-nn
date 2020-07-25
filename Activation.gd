extends Node
class_name Activation

enum Activations {
	SIGMOID,
	RELU,
	LEAKY_RELU,
	TAN_H,
	ARC_TAN,
#	ARC_SIN_H,
	BENT_IDENTITY,
	GAUSSIAN,
}

var activation_name := ""

var functions = {}
var activations_mapping = {
	Activations.SIGMOID: "sigmoid",
	Activations.RELU: "relu",
	Activations.LEAKY_RELU: "leaky_relu",
	Activations.TAN_H: "tan_h",
	Activations.ARC_TAN: "arc_tan",
	Activations.BENT_IDENTITY: "bent_identity",
	Activations.GAUSSIAN: "gaussian",
}


func _init(activation_fn) -> void:
	activation_name = activations_mapping[activation_fn]
	
	for key in Activations.keys():
		functions[Activations[key]] = {
			"forward": funcref(self, activations_mapping[Activations[key]]),
			"derivative": funcref(self, "d_" + activations_mapping[Activations[key]])
		}


func sigmoid(x: float, params={}):
	return 1 / (1 + exp(-1 * x))


func d_sigmoid(y: float, params={}):
	return y * (1 - y)


func relu(x: float, params={}):
	return 0.0 if x <= 0.0 else x


func d_relu(y: float, params={}):
	return 0.0 if y <= 0.0 else 1.0


func leaky_relu(x: float, params={}):
#	print("Val: ", (0.01 * x if x < 0.0 else x))
	return (0.01 * x if x < 0.0 else x)


func d_leaky_relu(y: float, params={}):
	return (0.01 if y < 0.0 else 1.0)


func tan_h(x: float, params={}):
	return tanh(x)


func d_tan_h(y: float, params={}):
	return 1 - pow(tanh(y), 2)


func arc_tan(x: float, params={}):
	return atan(x)


func d_arc_tan(y: float, params={}):
	return 1 / (pow(y, 2) + 1)


func bent_identity(x: float, params={}):
	return ((sqrt(pow(x, 2) + 1) - 1) / 2) + x


func d_bent_identity(y: float, params={}):
	return (y / (2 * sqrt(pow(y, 2) + 1))) + 1


func gaussian(x: float, params={}):
	return exp(pow(-1 * x, 2))


func d_gaussian(y: float, params={}):
	return -2 * y * exp(pow(-1 * y, 2))

