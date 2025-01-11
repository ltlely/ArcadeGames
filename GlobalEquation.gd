extends Node

var equation: String = ""  # Shared equation for all screens

func generate_random_equation() -> String:
	var valid_equation = false
	var equation = ""
	
	while not valid_equation:
		var num1 = randi_range(1, 99)
		var num2 = randi_range(1, 99)
		
		var operators = ["+", "-", "*", "/"]
		var operator = operators[randi_range(0, operators.size() - 1)]
		
		var result = 0
		match operator:
			"+": result = num1 + num2
			"-": result = num1 - num2
			"*": result = num1 * num2
			"/":
				if num2 != 0:
					result = num1 / num2
				else:
					continue
		
		if result >= 10 and result <= 99:
			equation = str(num1) + " " + operator + " " + str(num2)
			valid_equation = true
	
	return equation
