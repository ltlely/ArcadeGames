extends Control  # Make sure this is attached to the root node or scene.

# Declare the button and popup
onready var button = $HelpButton
onready var popup_panel = $Popup

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the button pressed signal to a function
	button.connect("pressed", self, "_on_button_pressed")

# Function that is called when the button is pressed
func _on_button_pressed():
	popup_panel.popup_centered()  # This makes the popup appear at the center
