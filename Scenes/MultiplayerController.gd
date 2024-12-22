extends Control

@export var Address = "127.0.0.1"
@export var port = 8910
var peer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called to server and clients when someone connects
func peer_connected(id): # id is server id
	print("Player Connected " + str(id))

# Called to server and client when someone disconnects
func peer_disconnected(id): # id assigned to player
	print("Player Disconnected " + str(id))

# Called when client connects to server
func connected_to_server(): # used to send info from client -> server
	print("Connected to Server!")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id()) # get the name 

# Called only from clients
func connection_failed():
	print("Couldnt Connect")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"score": 0
		}
	if multiplayer.is_server(): # server sends playerinfo to everyone else so that they will get an update
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)
	
@rpc("any_peer", "call_local") # how do you be called when starting game
func StartGame(): # load scene
	var scene = load("res://Scenes/firstWorld.tscn").instantiate()
	get_tree().root.add_child(scene) # add scene
	self.hide()
	
func _on_host_button_down() -> void:
	peer = ENetMultiplayerPeer.new() # set peer value as host
	var error = peer.create_server(port, 4)
	if error != OK:
		print("cannot host : " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) # gets more bandwidth // must be the same type throughout all program
	multiplayer.set_multiplayer_peer(peer) # use our host as our peer
	print("Waiting for Players!")
	# host sends info too
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	pass # Replace with function body.


func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) # gets more bandwidth
	multiplayer.set_multiplayer_peer(peer)
	
	pass # Replace with function body.


func _on_start_game_button_down() -> void:
	StartGame.rpc() # rpc or rpc_id to run
	pass # Replace with function body.
