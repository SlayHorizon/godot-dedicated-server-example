extends Node

signal connection_status_changed(is_connected: bool)
signal ping_received(latency: float)

const PORT := 6007
# localhost
const ADDRESS := "127.0.0.1"

var peer: ENetMultiplayerPeer

func connect_to_server() -> void:
	peer = ENetMultiplayerPeer.new()
	multiplayer.connected_to_server.connect(self._connection_succeeded)
	multiplayer.connection_failed.connect(self._connection_failed)
	peer.create_client(ADDRESS, PORT)
	multiplayer.set_multiplayer_peer(peer)

func disconnect_from_server() -> void:
	print("Disconnect from server.")
	close_connection()

func _connection_succeeded() -> void:
	print("Succesfuly connected to the server as %d!" % multiplayer.get_unique_id())
	connection_status_changed.emit(true)

func _connection_failed() -> void:
	print("Failed to connect to the server.")
	close_connection()

func close_connection():
	multiplayer.connected_to_server.disconnect(self._connection_succeeded)
	multiplayer.connection_failed.disconnect(self._connection_failed)
	peer.close()
	connection_status_changed.emit(false)
	multiplayer.set_multiplayer_peer(null)

@rpc("any_peer", "call_remote", "reliable", 0)
func ping(_msec: float) -> void:
	pass

@rpc("authority", "call_remote", "reliable", 0)
func pong(msec: float) -> void:
	var latency = Time.get_ticks_msec() - msec as float
	ping_received.emit(latency)
