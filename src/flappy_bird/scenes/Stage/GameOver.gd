extends Control


onready var anim := $GameOverAnim as AnimationPlayer

func _ready() -> void:
	hide()
	var bird = get_tree().root.find_node("Bird", true, false) as Bird
	if bird:
		bird.connect("state_changed", self, "_on_bird_state_changed")
	pass


func _on_bird_state_changed(bird: Bird) -> void:
	if bird.get_state() == bird.States.GROUNDED:
		show()
		anim.play("show")
	pass

