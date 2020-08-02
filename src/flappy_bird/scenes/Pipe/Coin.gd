extends Area2D


func _ready() -> void:
	var err := connect("body_entered", self, "_on_body_enter")
	if err != OK:
		print_debug("Error while connecting: ", err)
	pass


func _on_body_enter(other_body) -> void:
	if other_body.is_in_group(str(Game.Groups.BIRD)):
		Game.current_score += 1
		AudioLibrary.play("sfx_point")
	pass
