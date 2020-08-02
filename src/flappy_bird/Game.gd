extends Node

signal best_score_changed
signal current_score_changed

enum Groups {
	PIPES,
	GROUND,
	BIRD
}

var current_score := 0 setget set_current_score
var best_score := 0 setget set_best_score

var birds
var bird

const MEDAL_BRONZE = 1
const MEDAL_SILVER = 2
const MEDAL_GOLD = 3
const MEDAL_PLATINUM = 4

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_Back_pressed()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_on_Back_pressed()


func _on_Back_pressed():
	var scene_name = get_tree().get_current_scene().get_name()
	if scene_name == "MainStage":
		StageManager.change_stage(StageManager.MENU_STAGE)
	if scene_name == "MainMenu":
		get_tree().quit()
	pass


func set_current_score(new_val) -> void:
	current_score = new_val
	emit_signal("current_score_changed")
	pass


func set_best_score(new_val) -> void:
	if new_val > best_score:
		best_score = new_val
		emit_signal("best_score_changed")
	pass


func _ready() -> void:
	bird = get_bird()
	var err = StageManager.connect("stage_changed", self, "_on_stage_change")
	if err != OK:
		print_debug("Error while connecting", err)
	pass


func _process(_delta: float) -> void:
	bird = get_bird()
	pass


func get_bird():
	birds = get_tree().root.find_node("Birds", true, false).get_children() as Array
	if birds.size() <= 0:
		return null
	elif birds.size() == 1:
		return birds[0] as Bird
	else:
		# find the farthest bird
		var farthest_bird = birds[0]
		for bird in birds:
			if bird.position.x > farthest_bird.position.x:
				farthest_bird = bird
		return farthest_bird as Bird


func _on_stage_change() -> void:
	self.current_score = 0
	get_bird()
	pass
