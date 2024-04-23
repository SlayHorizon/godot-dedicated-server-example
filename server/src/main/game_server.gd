extends Node

const SERVER_PORT: int = 6007
const MAX_PEERS: int = 4

var player_list: Dictionary

var peer : ENetMultiplayerPeer

func _ready() -> void:
	start_server()


func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	multiplayer.peer_connected.connect(self._peer_connected)
	multiplayer.peer_disconnected.connect(self._peer_disconnected)
	peer.create_server(SERVER_PORT, MAX_PEERS)
	multiplayer.set_multiplayer_peer(peer)

func _peer_connected(peer_id) -> void:
	print("Peer: %d is connected." % peer_id)

func _peer_disconnected(peer_id) -> void:
	print("Peer: %d is disconnected." % peer_id)

@rpc("any_peer", "call_remote", "reliable", 0)
func ping(msec: float) -> void:
	var peer_id := multiplayer.get_remote_sender_id() as int
	rpc_id(peer_id, "pong", msec)

@rpc("authority", "call_remote", "reliable", 0)
func pong(_msec: float) -> void:
	pass
