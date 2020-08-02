extends Node

export var mute := false


func play(audio_name: String) -> void:
	if !mute:
		if get_node(audio_name) !=  null:
			(get_node(audio_name) as AudioStreamPlayer).play()
	pass
