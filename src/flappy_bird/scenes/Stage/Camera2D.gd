extends Camera2D

onready var bird := get_tree().root.find_node("Bird", true, false) as Bird

func _physics_process(_delta: float) -> void:
	position = Vector2(bird.position.x, position.y)
	pass


func get_total_pos():
	return position + offset
	pass
