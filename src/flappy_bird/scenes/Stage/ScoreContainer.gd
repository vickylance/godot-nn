extends HBoxContainer

signal counting_finished

const sprite_numbers = [
	preload("res://assets/flappy_bird/sprites/number_medium_0.png"),
	preload("res://assets/flappy_bird/sprites/number_medium_1.png"),
	preload("res://assets/flappy_bird/sprites/number_medium_2.png"),
	preload("res://assets/flappy_bird/sprites/number_medium_3.png"),
	preload("res://assets/flappy_bird/sprites/number_medium_4.png"),
	preload("res://assets/flappy_bird/sprites/number_medium_5.png"),
	preload("res://assets/flappy_bird/sprites/number_medium_6.png"),
	preload("res://assets/flappy_bird/sprites/number_medium_7.png"),
	preload("res://assets/flappy_bird/sprites/number_medium_8.png"),
	preload("res://assets/flappy_bird/sprites/number_medium_9.png"),
]


func _ready() -> void:
	var anim = get_tree().root.find_node("GameOverAnim", true, false) as AnimationPlayer
	yield(anim, "animation_finished")
	count_to_score()
	pass


func count_to_score() -> void:
	var lerp_time := 0.0
	var lerp_duration := 0.5
	
	while true:
		lerp_time += get_process_delta_time()
		lerp_time = min(lerp_time, lerp_duration)
		var percent = lerp_time / lerp_duration
		set_number(int(lerp(0, Game.current_score, percent)))
		
		if lerp_time >= lerp_duration:
			break
		yield(get_tree(), "idle_frame")
	Game.best_score = Game.current_score
	emit_signal("counting_finished")
	pass


func set_number(number: int) -> void:
	for child in get_children():
		child.free()
	update_score(number)
	pass


func update_score(number: int) -> void:
	var digits = get_digits(number)
	for digit in digits:
		var texture_rect = TextureRect.new()
		texture_rect.texture = sprite_numbers[digit]
		add_child(texture_rect)
	pass


func get_digits(score: int) -> Array:
	var str_score = str(score)
	var digits = []
	for i in range(str_score.length()):
		digits.append(str_score[i].to_int())
	return digits
	pass
