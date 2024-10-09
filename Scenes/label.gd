extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var equation = generate_random_equation()
	text = equation  # Set the text of the RichTextLabel to the generated equation

func generate_random_equation() -> String:
	var valid_equation = false
	var equation = ""
	
	while not valid_equation:
		# Generate two random numbers for operands
		var num1 = randi_range(1, 99)
		var num2 = randi_range(1, 99)
		
		# Randomly choose an operator
		var operators = ["+", "-", "*", "/"]
		var operator = operators[randi_range(0, operators.size() - 1)]
		
		# Calculate the result based on the operator
		var result = 0
		match operator:
			"+": result = num1 + num2
			"-": result = num1 - num2
			"*": result = num1 * num2
			"/":
				if num2 != 0:  # Avoid division by zero
					result = num1 / num2
				else:
					continue  # Skip this iteration if division by zero
		
		# Check if the result is a two-digit number
		if result >= 10 and result <= 99:
			equation = str(num1) + " " + operator + " " + str(num2)
			valid_equation = true
	return equation
