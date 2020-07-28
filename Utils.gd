extends Node

func map(x: float, in_min: float, in_max: float, out_min: float, out_max: float):
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

var previous_gaussian = false
var y2 = 0
func random_gaussian(mean, sd):
	var y1
	var x1
	var x2
	var w
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	if previous_gaussian:
		y1 = y2
		previous_gaussian = false
	else:
		while true:
			x1 = rng.randi_range(0, 1)
			x2 = rng.randi_range(0, 1)
			w = x1 * x1 + x2 * x2
			if w < 1:
				break
		w = sqrt(-2 * log(w) / w)
		y1 = x1 * w
		y2 = x2 * w
		previous_gaussian = true
	var m = mean or 0
	var s = sd or 1
	return y1 * s + m
	pass
