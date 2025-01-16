extends Control

@export var display_time: float = 1.0
@export var text_to_show: String = "text"

@onready var pop_up_scene: PackedScene = preload("res://Scenes/pop_up_setting.tscn")

var active_pop_up: Node = null

func _on_button_pressed() -> void:
	# If a popup is active, remove it (toggle off)
	if active_pop_up != null:
		active_pop_up.queue_free()
		active_pop_up = null
	else:
		# Create and configure a new popup
		var new_pop_up = pop_up_scene.instantiate()
		if new_pop_up.has_method("set_show_time"):
			new_pop_up.set_show_time(display_time)
		if new_pop_up.has_method("set_text_to_show"):
			new_pop_up.set_text_to_show(text_to_show)
		
		# Add it to the scene
		add_child(new_pop_up)
		active_pop_up = new_pop_up
