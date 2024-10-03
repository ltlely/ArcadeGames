extends Control


# Exported variables to configure the display time and text to show
@export var display_time: float = 1.0
@export var text_to_show: String = "text"

# Preloading the popup scene for better performance
@onready var pop_up_scene: PackedScene = preload("res://Scenes/popUp.tscn")

# This function is triggered when the button is pressed
func _on_button_pressed() -> void:
	# Create an instance of the popup scene
	var new_pop_up = pop_up_scene.instantiate()  # Correct method for instantiating in Godot 4

	# Make sure the popup scene has these properties (show_time, text_to_show)
	if new_pop_up.has_method("set_show_time"):
		new_pop_up.set_show_time(display_time)
	if new_pop_up.has_method("set_text_to_show"):
		new_pop_up.set_text_to_show(text_to_show)

	# Add the popup as a child to the current scene and display it
	add_child(new_pop_up)
