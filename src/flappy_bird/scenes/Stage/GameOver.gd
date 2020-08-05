extends Control


onready var anim := $GameOverAnim as AnimationPlayer

func _ready() -> void:
	hide()
	var err = Game.connect("all_birds_grounded", self, "_on_all_birds_grounded")
	if err != OK:
		print_debug("Error while connecting", err)
	pass


func _on_all_birds_grounded(state: bool) -> void:
	var ga = get_tree().root.find_node("GA", true, false) as GeneticAlgorithm
	if state == true and ga != null and !ga.run_simulation:
		display_game_over()


func display_game_over():
	show()
	anim.play("show")
	pass
