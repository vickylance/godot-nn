extends HBoxContainer

const sprite_numbers = [
	preload("res://assets/flappy_bird/sprites/number_large_0.png"),
	preload("res://assets/flappy_bird/sprites/number_large_1.png"),
	preload("res://assets/flappy_bird/sprites/number_large_2.png"),
	preload("res://assets/flappy_bird/sprites/number_large_3.png"),
	preload("res://assets/flappy_bird/sprites/number_large_4.png"),
	preload("res://assets/flappy_bird/sprites/number_large_5.png"),
	preload("res://assets/flappy_bird/sprites/number_large_6.png"),
	preload("res://assets/flappy_bird/sprites/number_large_7.png"),
	preload("res://assets/flappy_bird/sprites/number_large_8.png"),
	preload("res://assets/flappy_bird/sprites/number_large_9.png"),
]


func _ready() -> void:
	var err := Game.connect("current_score_changed", self, "_on_current_score_changed")
	if err != OK:
		print_debug("Error while connecting: ", err)
	var bird := Game.bird as Bird
	if bird:
		var err2 = bird.connect("state_changed", self, "_on_bird_state_changed")
		if err2 != OK:
			print_debug("Error while connecting", err2)
	update_score()
	pass


func _on_bird_state_changed(bird: Bird) -> void:
	if bird.get_state() == bird.States.HIT or bird.get_state() == bird.States.GROUNDED:
		hide()
	pass


func _on_current_score_changed() -> void:
	for child in get_children():
		child.queue_free()
	update_score()
	pass


func update_score() -> void:
	var digits = get_digits(Game.current_score)
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
