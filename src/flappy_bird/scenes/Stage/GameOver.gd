extends Control


onready var anim := $GameOverAnim as AnimationPlayer

func _ready() -> void:
	hide()
	var bird := Game.bird as Bird
	if bird:
		var err = bird.connect("state_changed", self, "_on_bird_state_changed")
		if err != OK:
			print_debug("Error while connecting", err)
	pass


func _on_bird_state_changed(bird: Bird) -> void:
	if bird.get_state() == bird.States.GROUNDED:
		show()
		anim.play("show")
	pass

