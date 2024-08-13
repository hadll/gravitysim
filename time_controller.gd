extends Node

var playing = false



func _on_play_pressed() -> void:
	playing = true
	%PauseButton.modulate = Color(1,1,1,1)
	%PlayButton.modulate = Color(1,1,1,0.3)


func _on_pause_pressed() -> void:
	playing = false
	%PlayButton.modulate = Color(1,1,1,1)
	%PauseButton.modulate = Color(1,1,1,0.3)

func _on_reset_pressed() -> void:
	for instance in %MassRegistry.instances:
		instance.queue_free()
