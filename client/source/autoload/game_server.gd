extends Node
## Game Server/Client side autoload.
## Focuses on maintaining a clean and minimal structure,
## handling only connection and authentication


# Signals for UI to update connection and latency status.
signal connection_changed(connected_to_server: bool)
signal ping_received(latency: float)

# Server configuration.
## The port the server listens to.
const SERVER_PORT: int = 6007
## The server address. Use "127.0.0.1" for local testing.
const SERVER_ADDRESS: String = "127.0.0.1"

# ENet-based peer for managing client-server communication over UDP.
var peer: ENetMultiplayerPeer

## True if the client is connected to the server.
var is_connected_to_server: bool = false:
	set(value):
		is_connected_to_server = value
		connection_changed.emit(value)


# Called when the node is added to the scene tree and ready to run.
func _ready() -> void:
	# Setup multiplayer signals.
	multiplayer.connected_to_server.connect(self._on_connection_succeeded)
	multiplayer.connection_failed.connect(self._on_connection_failed)
	multiplayer.server_disconnected.connect(self._on_server_disconnected)


# Called when the client successfully connects to the server.
func _on_connection_succeeded() -> void:
	print("Successfully connected to the server as %d!" % multiplayer.get_unique_id())
	is_connected_to_server = true


# Called when the connection attempt fails.
func _on_connection_failed() -> void:
	print("Failed to connect to the server.")
	close_connection()


# Called when the server disconnects.
func _on_server_disconnected() -> void:
	print("Server disconnected.")
	close_connection()


# Initiates a connection to the server.
func connect_to_server() -> void:
	print("Starting connection to the server at %s and on port %s." % [SERVER_ADDRESS, SERVER_PORT])
	peer = ENetMultiplayerPeer.new()
	
	var error: Error = peer.create_client(SERVER_ADDRESS, SERVER_PORT)
	if error != OK:
		printerr("Error while creating client (%s)." % error_string(error))
		return
	
	multiplayer.set_multiplayer_peer(peer)


# Disconnects the client from the server.
func disconnect_from_server() -> void:
	print("Disconnect from server.")
	close_connection()


# Closes the active connection and resets the peer.
func close_connection() -> void:
	multiplayer.set_multiplayer_peer(null)
	peer.close()
	is_connected_to_server = false


# Remote procedure call (RPC) to send ping.
@rpc("any_peer", "call_remote", "reliable", 0)
func ping(_sent_time_ms: float) -> void:
	pass


# RPC response to handle pong and emit latency value to GUI.
@rpc("authority", "call_remote", "reliable", 0)
func pong(sent_time_ms: float) -> void:
	# Round-Trip Time (RTT) - Client -> Server -> Client
	var rtt_ms: float = Time.get_ticks_msec() - sent_time_ms
	# One-way Latency - approximate: Client -> Server
	var ping_ms: float = rtt_ms * 0.5
	
	ping_received.emit(ping_ms)
	print("Ping received: estimated one-way latency = %.2fms." % ping_ms)
