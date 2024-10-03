extends Control

var text_to_show = """
- After 5 rounds, players switch roles.
- There are a total of 10 rounds.
- An "X" is marked if a player in the team clicks the wrong number in one of their team’s boxes, and they must move on to the next question.
- A checkmark is given if the player selects the correct number for both boxes.
- Players cannot change their answers once submitted.
"""

var show_time = 1.0

func _ready():
	# Access the Label node within ColorRect and set its text
	$ColorRect/Label.text = text_to_show
	
	# Start the timer to control how long the popup is shown
	$Timer.start(show_time)

# Function to handle the timer's timeout, removing the popup
func _on_Timer_timeout():
	queue_free()
