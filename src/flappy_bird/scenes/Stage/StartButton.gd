# script: StartButton.gd

extends TextureButton

func _ready() -> void:
	var scene_name = get_tree().get_current_scene().get_name()
	print("Scenename: ", scene_name)
	var err := connect("pressed", self, "_on_pressed")
	if err != OK:
		print_debug("Error while connecting: ", err)
	grab_focus()
	pass


func _on_pressed() -> void:
	for bird in Game.birds:
		if bird:
			bird.set_state(bird.States.FLAPPING)
	hide()
	pass
