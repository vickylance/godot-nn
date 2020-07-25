# script: Pipe.gd

extends StaticBody2D

onready var camera := get_tree().root.find_node("Camera", true, false) as Camera2D
onready var right := $Right as Position2D

func _ready() -> void:
	add_to_group(str(Game.Groups.PIPES))
	pass

func _process(_delta: float) -> void:
	if camera == null: return
	
	if right.global_position.x <= camera.get_total_pos().x:
		queue_free()
	pass
