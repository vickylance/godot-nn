extends Node
class_name NeuralNetwork


var input_nodes: Layer
var hidden_nodes := []
var output_nodes: Layer
var weights := []
var biases := []
var activation_functions = []
var learning_rate = 0.0
var Matrix = preload("res://Matrix.gd")


func _init(init_input_nodes: int, init_hidden_nodes: Array, init_output_nodes: Layer) -> void:
	self.input_nodes = Layer.new(init_input_nodes, 'Input')
	self.hidden_nodes = init_hidden_nodes
	self.output_nodes = init_output_nodes
	weights = []
	biases = []
	activation_functions = []
	var nodes = []
	nodes.append(self.input_nodes)
	nodes = nodes + hidden_nodes.duplicate(true)
	nodes.append(output_nodes)
	
	for i in range(nodes.size() - 1):
		var weight = Matrix.new(nodes[i + 1].nodes, nodes[i].nodes)
		weight.randomize_matrix()
		weights.append(weight)
		var bias = Matrix.new(nodes[i + 1].nodes, 1)
		bias.randomize_matrix()
		biases.append(bias)
	
	# only hidden and output layers can have activation functions
	var activation_layers = hidden_nodes.duplicate(true)
	activation_layers.append(output_nodes)
	for i in range(activation_layers.size()):
		activation_functions.append(activation_layers[i].activation_fn)
	
	setLearningRate()


func predict(input_array) -> Array:
	var output = Matrix.fromArray(input_array)
	for i in range(weights.size()):
		output = Matrix.dotProduct(weights[i], output)
		output.add(biases[i])
		output.map(activation_functions[i].forward)
	
	var output_arr = Matrix.toArray(output)
	return output_arr


func train(inputs_array, targets_array):
	#  Steps:-
	#  1. Get input & target array convert to matrix
	#  2. Forward propagate
	#    2.1 Dot product previous matrix with hidden matrix
	#    2.2 Add hidden bias
	#    2.3 Apply activation function
	#    2.4 Repeat 2.1 -> 2.3 until you reach output matrix
	#  3. Calculate the output error
	#  4. Back propagate
	#    4.1 Apply derivate activation function to the last layer.
	#    4.2 Hadamard product by the errors
	#    4.3 Scalar product by the learning rate
	#    4.4 Transpose the last before layer
	#    4.5 Dot product of output of 4.3 with 4.4
	#    4.6 Add the last weights matrix with output of 4.5
	#    4.7 Add the last bias matrix with the output of 4.3
	
	# Convert arr to matrix object
	var inputs = Matrix.fromArray(inputs_array);
	var targets = Matrix.fromArray(targets_array);
	
	var forward_weights = [];
	
	# forward prop
	for i in range(weights.size()):
		if (i == 0):
			var hidden = Matrix.dotProduct(weights[i], inputs)
			hidden.add(biases[i])
			hidden.map(activation_functions[i]["forward"])
			forward_weights.append(hidden)
		else:
			var hidden = Matrix.dotProduct(weights[i], forward_weights[i - 1])
			hidden.add(biases[i])
			hidden.map(activation_functions[i].forward)
			forward_weights.append(hidden)
	# Calculate the output error
	var errors = []
	for i in weights.size():
		errors.append(Matrix.new(1,1).randomize_matrix())
	errors[errors.size() - 1] = targets.subtract(
			forward_weights[forward_weights.size() - 1]);
	var gradients = [];
	# backward prop
	for i in range(weights.size() - 1, -1, -1):
		if (i != 0):
			# Calculate the hidden->output gradients
			var gradient = Matrix.immutableMap(
					forward_weights[i], activation_functions[i].derivative)
			gradient.multiply(errors[i])
			gradient.multiply(learning_rate)
			gradients.append(gradient)
			
			# Calculate the hidden->output deltas
			var hidden_T = Matrix.transpose(forward_weights[i - 1])
			var weight_delta = Matrix.dotProduct(gradient, hidden_T)
			# Update the hidden->output weights by deltas
			weights[i].add(weight_delta)
			biases[i].add(gradient)
			
			# Calculate the hidden layer error
			var who_t = Matrix.transpose(weights[i])
			errors[i - 1] = Matrix.dotProduct(who_t, errors[i])
		else:
			# Calculate the hidden->output gradients
			var gradient = Matrix.immutableMap(
					forward_weights[i], activation_functions[i].derivative)
			gradient.multiply(errors[i])
			gradient.multiply(learning_rate)
			gradients.append(gradient)
			
			# Calculate the hidden->output deltas
			var hidden_T = Matrix.transpose(inputs)
			var weight_delta = Matrix.dotProduct(gradient, hidden_T)
			# Update the hidden->output weights by deltas
			weights[i].add(weight_delta)
			biases[i].add(gradient)


func setLearningRate(new_learning_rate = 0.01) -> void:
	self.learning_rate = new_learning_rate


func setActivationFunction(new_activation_functions: Array) -> void:
	self.activation_functions = new_activation_functions


func clone():
	var NeuralNetwork = load("res://NeuralNetwork.gd")
	var clone = NeuralNetwork.new(input_nodes.nodes, hidden_nodes, output_nodes);
	for i in range(weights.size()):
		clone.weights[i] = Matrix.clone(weights[i])
	for i in range(biases.size()):
		clone.biases[i] = Matrix.clone(biases[i])
	clone.setLearningRate(learning_rate)
	clone.setActivationFunction(activation_functions)
	return clone


func mutate(mutation_rate = 0.1):
	var mutation_fn = funcref(self, "mutation_function")
	for weight in weights:
		weight.map(mutation_fn, {mutation_rate = mutation_rate})
	for bias in biases:
		bias.map(mutation_fn, {mutation_rate = mutation_rate})


func mutation_function(val, params={}):
	var mutation_rate = params.mutation_rate if params.mutation_rate != null else 0.05
	randomize()
	if(randf() < mutation_rate):
#		return Utils.map(rand_range(0, 1), 0, 1, -1, 1)
		return val + Utils.random_gaussian(0, 0.1)
	else:
		return val
