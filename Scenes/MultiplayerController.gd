extends Control

@export var Address = "127.0.0.1"
@export var port = 8910
var peer

# Shared variables for the equations
var current_equation : String
var current_equation2 : String

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	pass # Replace with function body.

# Called every frame
func _process(delta: float) -> void:
	pass

# Called when someone connects
func peer_connected(id): 
	print("Player Connected " + str(id))

# Called when someone disconnects
func peer_disconnected(id): 
	print("Player Disconnected " + str(id))

# Called when client connects to the server
func connected_to_server(): 
	print("Connected to Server!")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id()) 

# Called only from clients
func connection_failed():
	print("Couldn't Connect")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)

@rpc("any_peer", "call_local")
func StartGame():
	if multiplayer.is_server():  # Only the server generates the equations
		# Generate the first equation
		current_equation = generate_random_equation()
		SyncEquation.rpc(current_equation)  # Broadcast the first equation to all players

		# Generate the second equation
		current_equation2 = generate_random_equation()
		SyncEquation2.rpc(current_equation2)  # Broadcast the second equation to all players

	# Load the game scene
	var scene = load("res://Scenes/firstWorld.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

	# Set the first equation on the UI if it exists in the new scene
	var equation_label = scene.get_node("Background/InnerBox/Label")
	if equation_label:
		equation_label.text = current_equation

	# Set the second equation on the UI if it exists in the new scene
	var equation_label2 = scene.get_node("Background/InnerBox/Label2")
	if equation_label2:
		equation_label2.text = current_equation2

@rpc("any_peer")
func SyncEquation(equation: String):
	# Sync the first equation
	current_equation = equation
	print("First equation received: " + current_equation)

	# Update the first label if the game scene is already loaded
	var equation_label = get_tree().root.get_node("FirstWorld/Background/InnerBox/Label")
	if equation_label:
		equation_label.text = current_equation

@rpc("any_peer")
func SyncEquation2(equation: String):
	# Sync the second equation
	current_equation2 = equation
	print("Second equation received: " + current_equation2)

	# Update the second label if the game scene is already loaded
	var equation_label2 = get_tree().root.get_node("FirstWorld/Background/InnerBox/Label2")
	if equation_label2:
		equation_label2.text = current_equation2

# Function to generate a random equation
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

# Host button down - for creating a server
func _on_host_button_down() -> void:
	peer = ENetMultiplayerPeer.new()  # set peer value as host
	var error = peer.create_server(port, 4)
	if error != OK:
		print("cannot host : " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)  # gets more bandwidth
	multiplayer.set_multiplayer_peer(peer)  # use our host as our peer
	print("Waiting for Players!")
	# Host sends info too
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())

# Join button down - for connecting as client
func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)  # gets more bandwidth
	multiplayer.set_multiplayer_peer(peer)

# Start game button down
func _on_start_game_button_down() -> void:
	StartGame.rpc()  # RPC or rpc_id to run
