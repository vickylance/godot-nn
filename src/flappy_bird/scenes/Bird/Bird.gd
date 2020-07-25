# script: Bird

extends RigidBody2D
class_name Bird

signal state_changed

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

func _ready() -> void:
	add_to_group(str(Game.Groups.BIRD))
	state = FlyingState.new(self)
	var err := connect("body_entered", self, "_on_body_entered")
	if err != OK:
		print_debug("Error while connecting: ", err)
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
		pass
	
	
	func input(event: InputEvent) -> void:
		if event.is_action_pressed("flap"):
			flap()
		pass
	
	
	func unhandled_input(event: InputEvent) -> void:
		if !(event is InputEventMouseButton) or !event.is_pressed() or event.is_echo():
			return
		
		if event.button_index == BUTTON_LEFT:
			flap()
		pass
	
	
	func exit() -> void:
		pass
	
	
	func on_body_enter(other_body) -> void:
		if other_body.is_in_group(str(Game.Groups.PIPES)):
			print("Set state HIT")
			bird.set_state(bird.States.HIT)
		elif other_body.is_in_group(str(Game.Groups.GROUND)):
			print("Set state GROUND")
			bird.set_state(bird.States.GROUNDED)
		pass
	
	
	func flap() -> void:
		bird.linear_velocity = Vector2(bird.linear_velocity.x, -bird.flap_power)
		bird.angular_velocity = -3
		bird.get_node("Anim").play("Flapping")
		
		AudioLibrary.find_node("sfx_wing").play()
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
		
		AudioLibrary.find_node("sfx_hit").play()
		AudioLibrary.find_node("sfx_die").play()
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
			AudioLibrary.find_node("sfx_hit").play()
		pass
	
	
	func update(_delta: float) -> void:
		pass
	
	
	func input(_event) -> void:
		pass
	
	
	func exit() -> void:
		pass
	
	pass
