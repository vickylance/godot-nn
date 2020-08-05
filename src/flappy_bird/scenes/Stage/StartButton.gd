# script: StartButton.gd

extends TextureButton

signal game_started

func _ready() -> void:
#	var scene_name = get_tree().get_current_scene().get_name()
	Game.all_birds_grounded = false
	var err := connect("pressed", self, "_on_pressed")
	if err != OK:
		print_debug("Error while connecting: ", err)
	grab_focus()
	var ga = (get_tree().root.find_node("GA", true, false) as GeneticAlgorithm)
	if ga != null:
		ga.connect("spawned_next_gen", self, "_on_spawned_next_gen")
	pass


func _on_spawned_next_gen(birds) -> void:
	hide()
	call_deferred("change_birds_state", birds)
	pass


func _on_pressed() -> void:
	hide()
	change_birds_state(Game.birds)
	emit_signal("game_started")
	pass


func change_birds_state(birds) -> void:
	print("change state of birds: ")
	for bird in birds:
		if bird:
			bird.set_state(bird.States.FLAPPING)
	pass
