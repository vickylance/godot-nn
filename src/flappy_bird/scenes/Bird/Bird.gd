# script: Bird

extends RigidBody2D
class_name Bird

signal state_changed

export var brain_train := false
export var flap_power := 150
export var forward_speed := 50


enum States {
	FLYING,
	HIT,
	FLAPPING,
	GROUNDED
}
var state
var prev_state
var brain: NeuralNetwork
var fitness
var score

func _ready() -> void:
	add_to_group(str(Game.Groups.BIRD))
	state = FlyingState.new(self)
	var err := connect("body_entered", self, "_on_body_entered")
	if err != OK:
		print_debug("Error while connecting: ", err)
	if brain_train:
		brain = NeuralNetwork.new(2,
			[
				Layer.new(3, Activation.Activations.LEAKY_RELU),
				Layer.new(3, Activation.Activations.LEAKY_RELU)
			],
			Layer.new(1, Activation.Activations.SIGMOID))
	pass


func _physics_process(delta: float) -> void:
	state.update(delta)
	pass


func _input(event: InputEvent) -> void:
	state.input(event)
	pass


func _unhandled_input(event: InputEvent) -> void:
	if state.has_method("unhandled_input"):
		state.unhandled_input(event)
	pass


func _on_body_entered(other_body) -> void:
	if state.has_method("on_body_enter"):
		state.on_body_enter(other_body)
	pass


func set_state(new_state) -> void:
	state.exit()
	prev_state = get_state()
	
	match(new_state):
		States.FLYING:
			state = FlyingState.new(self)
		States.FLAPPING:
			state = FlappingState.new(self)
		States.HIT:
			state = HitState.new(self)
		States.GROUNDED:
			state = GroundedState.new(self)
	
	emit_signal("state_changed", self)
	pass


func get_state():
	if state is FlyingState:
		return States.FLYING
	elif state is FlappingState:
		return States.FLAPPING
	elif state is HitState:
		return States.HIT
	elif state is GroundedState:
		return States.GROUNDED
	pass


# class FlyingState

class FlyingState:
	var bird: Bird
	var prev_gravity_scale: float
	
	func _init(bird_inst: Bird) -> void:
		bird = bird_inst
		bird.get_node("Anim").play("Flying")
		bird.linear_velocity = Vector2(bird.forward_speed, bird.linear_velocity.y)
		prev_gravity_scale = bird.gravity_scale
		bird.gravity_scale = 0
		pass
	
	
	func update(_delta) -> void:
		pass
	
	
	func input(_event) -> void:
		pass
	
	
	func exit() -> void:
		bird.gravity_scale = prev_gravity_scale
		bird.get_node("Anim").stop()
		bird.get_node("AnimSprite").position = Vector2.ZERO
		pass
	
	pass

# class FlappingState

class FlappingState:
	var bird: Bird
	
	func _init(bird_inst: Bird) -> void:
		bird = bird_inst
		
		bird.linear_velocity = Vector2(bird.forward_speed, bird.linear_velocity.y)
		flap()
		pass
	
	
	func update(_delta) -> void:
		if bird.rotation_degrees < -30:
			bird.rotation_degrees = -30
			bird.angular_velocity = 0
		
		if bird.linear_velocity.y > 0:
			bird.angular_velocity = 2
		
		# if the bird hits ceiling
		if bird.position.y < 0:
			bird.set_state(bird.States.HIT)
		
		if bird.brain_train:
			think()
		pass
	
	
	func input(event: InputEvent) -> void:
		if bird.brain_train: return
		if event.is_action_pressed("flap"):
			flap()
		pass
	
	
	func unhandled_input(event: InputEvent) -> void:
		if bird.brain_train: return
		if !(event is InputEventMouseButton) or !event.is_pressed() or event.is_echo():
			return
		
		if event.button_index == BUTTON_LEFT:
			flap()
		pass
	
	
	func exit() -> void:
		pass
	
	
	func on_body_enter(other_body) -> void:
		if other_body.is_in_group(str(Game.Groups.PIPES)):
			bird.set_state(bird.States.HIT)
		elif other_body.is_in_group(str(Game.Groups.GROUND)):
			bird.set_state(bird.States.GROUNDED)
		pass
	
	
	func think():
		# find the closest pipe
		var closest_pipe = null
		var closest_pipe_distance = 1000.0
		var pipes = bird.get_tree().root.find_node("SpawnerPipe", true, false).get_node("Container").get_children()
		if pipes.size() > 0:
			for pipe in pipes:
				var distance =  pipe.position.x - bird.position.x
				if distance < closest_pipe_distance and distance > 0:
					closest_pipe = pipe
					closest_pipe_distance = distance
		if not closest_pipe: return
		
		# find bird horizontal and vertical distance from pipe
		var right := closest_pipe.find_node("Right", true, false) as Position2D
		var bird_h
		var bird_v
		if right:
			bird_h = (right.position.x - bird.position.x) / bird.get_viewport().size.x # normalize with screen width
			bird_v = (right.position.y - bird.position.y) / bird.get_viewport().size.y # normalize with screen height
		
		# calculate fitness
		bird.fitness = bird.position.x - closest_pipe_distance
		
		# predict
		var inputs = [bird_h, bird_v]
		var output := bird.brain.predict(inputs)
		if output[0] > 0.5:
			flap()
		pass
	
	
	func calculate_fitness() -> void:
		pass
	
	
	func flap() -> void:
		bird.linear_velocity = Vector2(bird.linear_velocity.x, -bird.flap_power)
		bird.angular_velocity = -3
		bird.get_node("Anim").play("Flapping")
		
		AudioLibrary.play("sfx_wing")
		pass
	
	pass

# class HitState

class HitState:
	var bird: Bird
	
	func _init(bird_inst: Bird):
		bird = bird_inst
		
		bird.linear_velocity = Vector2.ZERO
		bird.angular_velocity = 2
		
		if bird.get_colliding_bodies().size() > 0:
			var other_body = bird.get_colliding_bodies()[0]
			bird.add_collision_exception_with(other_body)
		
		AudioLibrary.play("sfx_hit")
		AudioLibrary.play("sfx_die")
		pass
	
	
	func update(_delta: float) -> void:
		pass
	
	
	func input(_event) -> void:
		pass
	
	
	func exit() -> void:
		pass
	
	
	func on_body_enter(other_body) -> void:
		if other_body.is_in_group(str(Game.Groups.GROUND)):
			bird.set_state(bird.States.GROUNDED)
		pass
	
	pass

# class GroundedState

class GroundedState:
	var bird: Bird
	
	func _init(bird_inst: Bird):
		bird = bird_inst
		
		bird.linear_velocity = Vector2.ZERO
		bird.angular_velocity = 0
		bird.sleeping = true
		
		if bird.prev_state != bird.States.HIT:
			AudioLibrary.play("sfx_hit")
		pass
	
	
	func update(_delta: float) -> void:
		pass
	
	
	func input(_event) -> void:
		pass
	
	
	func exit() -> void:
		pass
	
	pass
