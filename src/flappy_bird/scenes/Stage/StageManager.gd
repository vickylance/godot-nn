extends CanvasLayer

signal stage_changed

const GAME_STAGE = "res://src/flappy_bird/scenes/Stage/Stage.tscn"
const MENU_STAGE = "res://src/flappy_bird/scenes/MainMenu/MainMenu.tscn"

var is_changing = false


func change_stage(stage_path: String) -> void:
	if is_changing: return
	
	is_changing = true
	get_tree().root.set_disable_input(true)
	
	# fade to black
	get_node("Fill").visible = true
	get_node("Anim").play("fade_in")
	AudioLibrary.find_node("sfx_swooshing").play()
	yield(get_node("Anim"), "animation_finished")
	
	# change scene
	var err := get_tree().change_scene(stage_path)
	if err != OK:
		print_debug("Error while changing scene: ", err)
	emit_signal("stage_changed")
	
	# fade from black
	get_node("Anim").play("fade_out")
	yield(get_node("Anim"), "animation_finished")
	get_node("Fill").visible = false
	
	is_changing = false
	get_tree().root.set_disable_input(false)
	pass
