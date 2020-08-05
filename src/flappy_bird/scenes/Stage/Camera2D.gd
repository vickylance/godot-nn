extends Camera2D

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
#	if position == Vector2.ZERO:
#		print("Cam reset", position)
	if Game.bird:
		position = Vector2(Game.bird.position.x, position.y)
	pass


func get_total_pos():
	return position + offset
	pass
