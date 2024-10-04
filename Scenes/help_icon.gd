extends Sprite2D

# Function to toggle visibility
func toggle_visibility(whose):
	if whose.is_visible():
		whose.hide()
	else:
		whose.show()

# Function called when the button is pressed
func _on_button_pressed():
	# Print the root node and its children for debugging
	print("Root children:", get_tree().get_root().get_children())
	print("Parent children:", get_node("..").get_children())  # This shows the children of the parent node

	var help_panel = get_tree().get_root().find_node("HelpPanel")  # Attempt to find HelpPanel globally
	print(help_panel)  # Print the reference to the HelpPanel node
	toggle_visibility(help_panel)  # Toggle the visibility of HelpPanel
