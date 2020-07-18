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
#	var mat1 = Matrix.new(4, 4)
#	print(mat1.rows)
#	print(mat1.cols)
#	print(str(mat1))
#	mat1.randomize_matrix()
#	print(str(mat1))
#	mat1.zeros()
#	print(str(mat1))
#	var a = Matrix.new(2,2)
#	var b = Matrix.new(2,2)
#	a.ones()
#	b.ones()
#	var mat2 = Matrix.dotProduct(Matrix.clone(mat1.zeros()), Matrix.clone(mat1.ones()))
#	print(str(mat2))
#	print(Matrix.fromArray([1,2,3,4]))
#	print(Matrix.toArray(a.randomize_matrix()))
#	print("-------------------")
#	print(Matrix.new(2,3, 345).ones().add(5).add(Matrix.new(2,3, 345).ones()))
#	print(Matrix.new(2,3).ones().multiply(40))
#	print("-------------------")
#	var square_ref = funcref(self, 'square')
#	var x = Matrix.new(2,3).ones().multiply(2)
#	x.map(square_ref)
#	print("Before: ", x)
#	var y = Matrix.immutableMap(x, square_ref)
#	print("After: ", x)
#	print(y)
#	print(Matrix.transpose(Matrix.new(2,3).ones()))
#	print(Matrix.clone(y).multiply(2))
#	print(y)

#	var x = [1,2,3]
#	print(x)
#	var y = x.duplicate()
#	print(y)
#	y[0] = 4
#	print(y)
#	print(x)
	
#	var x = 1
#	print(x)
#	var y = x
#	print(y)
#	y = 4
#	print(y)
#	print(x)
	
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
	
#	print(Matrix.fromArray(train_data[0]['inputs']))
#	print(Matrix.fromArray(train_data[0]['outputs']))
#	print(Activations.keys())
#	for kye in Activations.keys():
#		print(Activations[kye])
#	for i in range(train_data.size() - 1, -1, -1):
#		print(i)
#		pass
#	print(typeof(5.0) == TYPE_REAL)
	
	
#	var m1 = Matrix.new(1,3)
#	var m2 = Matrix.new(3,2)
##	[
##	-0.924299
##	-0.198697
##	-0.233986
##	]
#	m1.matrix[0][0] = -0.924299
#	m1.matrix[0][1] = -0.198697
#	m1.matrix[0][2] = -0.233986
##	[
##-0.122692, -0.801608, -0.786912
##0.588215, -0.353823, 0.119837
##]
#	m2.matrix[0][0] = -0.122692
#	m2.matrix[0][1] = 0.588215
#	m2.matrix[1][0] = -0.801608
#	m2.matrix[1][1] = -0.353823
#	m2.matrix[2][0] = -0.786912
#	m2.matrix[2][1] = 0.119837
#	print(Matrix.dotProduct(m1, m2))


#	var mat1 = Matrix.fromArray(train_data[0]["inputs"])
#	print(mat1)
#	mat1.matrix[0][0] = 5.0
#	print(mat1)
#	print(train_data[0]["inputs"])
#	mat1.matrix[0][0] = 5.0
#	print(mat1)
#	print(train_data[0]["inputs"])
	pass


func square(val):
	return pow(val, val)















