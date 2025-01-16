extends Control

# Properties to set display time and text
var display_time: float = 5.0
var text_to_show: String = "Default Text"

# Called to set the display time
func set_show_time(time: float) -> void:
	display_time = time

# Called to set the text
func set_text_to_show(text: String) -> void:
	text_to_show = text
	# Update the text in a label (if you have one in the popup scene)
	if has_node("Label"):
		$Label.text = text

# Display the popup and auto-hide after display_time
func _ready() -> void:
	show()
	# Use a timer to hide the popup after the specified time
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = display_time
	add_child(timer)
	timer.start()
	timer.timeout.connect(self.queue_free)  # Remove popup when timer ends
