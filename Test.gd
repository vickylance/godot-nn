extends Node

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


func _ready() -> void:
	var Matrix = load("res://Matrix.gd")
	
	var brain = NeuralNetwork.new(2,
			[
				Layer.new(3, Activation.Activations.LEAKY_RELU),
				Layer.new(2, Activation.Activations.LEAKY_RELU)
			],
			Layer.new(1, Activation.Activations.SIGMOID))

	print("Initialized weights and biases")
	print(brain.weights)
	print("---------------------------")

	var train_data = [
		{
			'inputs': [1.0, 1.0],
			'outputs': [0.0],
		},
		{
			'inputs': [0.0, 0.0],
			'outputs': [0.0],
		},
		{
			'inputs': [0.0, 1.0],
			'outputs': [1.0],
		},
		{
			'inputs': [1.0, 0.0],
			'outputs': [1.0],
		}
	];
	var epoch = 100000;
	brain.setLearningRate(0.01)

	for i in range(epoch):
		var rand_data = train_data[randi() % train_data.size()]
		brain.train(rand_data['inputs'], rand_data['outputs'])

#	for i in range(epoch):
#		randomize()
#		var idx = floor(rand_range(0, 4))
#		brain.train(train_data[idx]['inputs'], train_data[idx]['outputs'])

	print("Trained weights and biases")
	print(brain.weights)
	print("---------------------------")

	for i in range(train_data.size()):
		print("Test: In: ", train_data[i]['inputs'],  " Out: ",  brain.predict(train_data[i]['inputs']))
	
	for weight in brain.weights:
		print("Weight")
		print(weight)
		pass
	
	var brain2 = brain.clone()
	print("Before Mutation:", brain2.weights)
	brain2.mutate(0.5)
	print("After Mutation: ", brain2.weights)
	pass


func square(val):
	return pow(val, val)















