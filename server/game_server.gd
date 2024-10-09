extends Node
## Game Server side autoload.
## Focuses on maintaining a clean and minimal structure,
## handling only connection and authentication

# Server configuration.
## The port the server listens to. Ensure it's opened, especially for remote testing.
const SERVER_PORT: int = 6007

## The maximum number of peers allowed to connect at once.
const MAX_PEERS: int = 4

# ENet-based peer for managing client-server communication over UDP.
var peer: ENetMultiplayerPeer


# Called when the node is added to the scene tree and ready to run.
func _ready() -> void:
	start_server()


# Starts the server and sets up peer connections.
func start_server() -> void:
	print("Starting server.")
	peer = ENetMultiplayerPeer.new()
	
	multiplayer.peer_connected.connect(self._on_peer_connected)
	multiplayer.peer_disconnected.connect(self._on_peer_disconnected)
	
	peer.create_server(SERVER_PORT, MAX_PEERS)
	multiplayer.set_multiplayer_peer(peer)


# Called when a new peer successfully connects to the server.
func _on_peer_connected(peer_id: int) -> void:
	print("Peer: %d is connected." % peer_id)


# Called when a peer disconnects from the server.
func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer: %d is disconnected." % peer_id)


# Remote procedure call (RPC) to receive ping from clients.
@rpc("any_peer", "call_remote", "reliable", 0)
func ping(msec: float) -> void:
	var peer_id := multiplayer.get_remote_sender_id() as int
	pong.rpc_id(peer_id, msec)


# RPC response to handle pong from clients.
@rpc("authority", "call_remote", "reliable", 0)
func pong(_msec: float) -> void:
	pass
