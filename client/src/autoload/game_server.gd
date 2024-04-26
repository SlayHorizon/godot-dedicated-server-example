extends Node

# These signals will be used for UI.
signal connection_changed(new_connection_status: bool)
signal ping_received(latency: float)

# Server informations,
# you may want to replace them my variables.
const PORT := 6007
const ADDRESS := "127.0.0.1" # locahost

var peer: ENetMultiplayerPeer
var connection_status: bool = false:
	set(value):
		connection_status = value
		connection_changed.emit(value)

func connect_to_server() -> void:
	peer = ENetMultiplayerPeer.new()
	multiplayer.connected_to_server.connect(self._on_connection_succeeded)
	multiplayer.connection_failed.connect(self._on_connection_failed)
	multiplayer.server_disconnected.connect(self._on_server_disconnected)
	peer.create_client(ADDRESS, PORT)
	multiplayer.set_multiplayer_peer(peer)

func disconnect_from_server() -> void:
	print("Disconnect from server.")
	close_connection()

func close_connection():
	multiplayer.connected_to_server.disconnect(self._on_connection_succeeded)
	multiplayer.connection_failed.disconnect(self._on_connection_failed)
	multiplayer.server_disconnected.disconnect(self._on_server_disconnected)
	multiplayer.set_multiplayer_peer(null)
	peer.close()
	connection_status = false

@rpc("any_peer", "call_remote", "reliable", 0)
func ping(_msec: float) -> void:
	pass

@rpc("authority", "call_remote", "reliable", 0)
func pong(msec: float) -> void:
	var latency = (Time.get_ticks_msec() - msec) / 1000.0 as float
	ping_received.emit(latency)

func _on_connection_succeeded() -> void:
	print("Succesfuly connected to the server as %d!" % multiplayer.get_unique_id())
	connection_status = true

func _on_connection_failed() -> void:
	print("Failed to connect to the server.")
	close_connection()

func _on_server_disconnected() -> void:
	print("Server disconnected.")
	close_connection()
