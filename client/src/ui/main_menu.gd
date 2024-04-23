extends Control

func _ready():
	GameServer.connection_status_changed.connect(self._on_connection_status_changed)
	GameServer.ping_received.connect(self._ping_received)


func _on_connect_button_pressed() -> void:
	%ConnectButton.disabled = true
	GameServer.connect_to_server()

func _on_disconnect_button_pressed() -> void:
	GameServer.disconnect_from_server()

func _on_ping_button_pressed():
	if GameServer.peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		GameServer.rpc_id(1, "ping", Time.get_ticks_msec())
	else:
		GameServer.connection_status_changed.emit(false)

func _on_connection_status_changed(is_connected: bool) -> void:
	if is_connected:
		%MessageStatusLabel.text = "Connected to the server!"
		%DisconnectButton. disabled = false
		%PingButton.disabled = false
	else:
		%MessageStatusLabel.text = "Offline."
		%ConnectButton.disabled = false
		%DisconnectButton. disabled = true
		%PingButton.disabled = true

func _ping_received(ping: float):
	%PingLabel.text = "Ping = %.2fms" % ping
