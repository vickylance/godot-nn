extends Resource

var rows
var cols
var matrix
var rnd


static func fromArray(arr):
	var Matrix = load("res://Matrix.gd")
	var result = Matrix.new(arr.size(), 1)
	for i in range(arr.size()):
		result.matrix[i][0] = arr[i]
	return result


static func toArray(mat):
	var result = []
	for i in range(mat.rows):
		for j in range(mat.cols):
			var elem = mat.matrix[i][j]
			result.append(elem)
	return result


static func dotProduct(a, b):
	assert(a.cols == b.rows, 'The columns of A = ${a.cols} must match rows of B = ${b.rows}')
	var Matrix = load("res://Matrix.gd")
	var result = Matrix.new(a.rows, b.cols)
	for i in range(result.rows):
		for j in range(result.cols):
			var sum = 0.0
			for k in range(a.cols):
				sum += a.matrix[i][k] * b.matrix[k][j]
			result.matrix[i][j] = sum
	return result


static func clone(x):
	var Matrix = load("res://Matrix.gd")
	var result = Matrix.new(x.rows, x.cols)
	for i in range(x.rows):
		for j in range(x.cols):
			result.matrix[i][j] = x.matrix[i][j]
	return result


static func transpose(x):
	var Matrix = load("res://Matrix.gd")
	var result = Matrix.new(x.cols, x.rows)
	for i in range(x.rows):
		for j in range(x.cols):
			result.matrix[j][i] = x.matrix[i][j]
	return result


static func immutableMap(m, fn: FuncRef):
	var Matrix = load("res://Matrix.gd")
	var result = Matrix.new(m.rows, m.cols)
	for i in range(m.rows):
		for j in range(m.cols):
			result.matrix[i][j] = fn.call_func(m.matrix[i][j])
	return result


func map(fn: FuncRef):
	for i in range(rows):
		for j in range(cols):
			var val = matrix[i][j]
			matrix[i][j] = fn.call_func(val)
	return self


func multiply(val):
	for i in range(rows):
		for j in range(cols):
			if typeof(val) == TYPE_INT or typeof(val) == TYPE_REAL:
				# Scalar product
				matrix[i][j] *= val
			else:
				# Hadamard product
				matrix[i][j] *= val.matrix[i][j]
	return self


func add(val):
	for i in range(rows):
		for j in range(cols):
			if typeof(val) == TYPE_INT:
				# scalar addition
				matrix[i][j] += val
			else:
				# matrix addition
				matrix[i][j] += val.matrix[i][j]
	return self


func subtract(val):
	for i in range(rows):
		for j in range(cols):
			if typeof(val) == TYPE_INT:
				# scalar subtraction
				matrix[i][j] -= val
			else:
				# matrix subtraction
				matrix[i][j] -= val.matrix[i][j]
	return self


func ones():
	for i in range(rows):
		for j in range(cols):
			matrix[i][j] = 1.0
	return self


func zeros():
	for i in range(rows):
		for j in range(cols):
			matrix[i][j] = 0.0
	return self


func randomize_matrix(min_range = -1, max_range = 1):
	randomize()
	for i in range(rows):
		for j in range(cols):
			matrix[i][j] = Utils.map(rand_range(0, 1), 0, 1, min_range, max_range)
	return self


func intialize():
	matrix = []
	for x in range(rows):
			var col = []
			col.resize(cols)
			matrix.append(col)
	return matrix


func _to_string() -> String:
	var m = '[\n'
	for i in range(rows):
		for j in range(cols):
			m += str("%.10f" % matrix[i][j]) + ("" if (j + 1 == cols) else ', ')
		m += '\n'
	return m + ']'


func _init(rows, cols):
	rnd = rand_range(0, 1)
	self.rows = rows
	self.cols = cols
	intialize()
	return self

