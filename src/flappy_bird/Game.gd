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

const MEDAL_BRONZE = 1
const MEDAL_SILVER = 2
const MEDAL_GOLD = 3
const MEDAL_PLATINUM = 4

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
	StageManager.connect("stage_changed", self, "_on_stage_change")
	pass


func _on_stage_change() -> void:
	self.current_score = 0
	pass
