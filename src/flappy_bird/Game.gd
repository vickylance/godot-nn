extends Node

signal best_score_changed
signal current_score_changed
signal all_birds_grounded(state)

enum Groups {
	PIPES,
	GROUND,
	BIRD
}

var current_score := 0 setget set_current_score
var best_score := 0 setget set_best_score

var birds: Array
var bird
var all_birds_grounded := false setget set_all_birds_grounded
var GA

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


func set_all_birds_grounded(new_val) -> void:
	all_birds_grounded = new_val
	emit_signal("all_birds_grounded", new_val)


func _ready() -> void:
	bird = get_bird()
	var err = StageManager.connect("stage_changed", self, "_on_stage_change")
	if err != OK:
		print_debug("Error while connecting", err)
	pass


func _process(_delta: float) -> void:
	bird = get_bird()
	check_all_birds_grounded()
	if GA == null:
		GA = get_tree().root.find_node("GA", true, false) as GeneticAlgorithm
		if GA != null:
			print("GA found")
			var err2 = GA.connect("spawned_next_gen", self, "_on_spawned")
			if err2 != OK:
				print_debug("Error while connecting", err2)
	pass


func check_all_birds_grounded() -> void:
	var dead_count = 0
	for i_bird in birds:
		if i_bird.get_state() == i_bird.States.GROUNDED:
			dead_count += 1
	if dead_count == birds.size() and !all_birds_grounded:
		self.all_birds_grounded = true


func get_bird():
	if get_tree().root.find_node("Birds", true, false) == null: return
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
	reset()
	pass


func _on_spawned(_population) -> void:
	reset()
	pass


func reset() -> void:
	self.current_score = 0
	self.all_birds_grounded = false
	get_bird()
