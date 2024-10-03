extends TextureButton



func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/startingScreen.tscn")

func _on_help_button_pressed() -> void:
	pass # Replace with function body.
