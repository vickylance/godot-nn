# script: StartButton.gd

extends TextureButton

func _ready() -> void:
	var err := connect("pressed", self, "_on_pressed")
	if err != OK:
		print_debug("Error while connecting: ", err)
	grab_focus()
	pass


func _on_pressed() -> void:
	var bird := get_tree().root.find_node("Bird", true, false)
	if bird:
		bird.set_state(bird.States.FLAPPING)
	
	hide()
	pass
