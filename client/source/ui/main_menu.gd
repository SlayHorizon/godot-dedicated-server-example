extends Control


func _ready() -> void:
	GameServer.connection_changed.connect(self._on_connection_changed)
	GameServer.ping_received.connect(self._on_ping_received)


func _on_connect_button_pressed() -> void:
	%ConnectButton.disabled = true
	GameServer.connect_to_server()


func _on_disconnect_button_pressed() -> void:
	GameServer.disconnect_from_server()


func _on_ping_button_pressed() -> void:
	GameServer.ping.rpc_id(1, Time.get_ticks_msec())


func _on_connection_changed(connection_status: bool) -> void:
	if connection_status:
		%MessageStatusLabel.text = "Connected to the server!"
		%DisconnectButton. disabled = false
		%PingButton.disabled = false
	else:
		%MessageStatusLabel.text = "Offline."
		%ConnectButton.disabled = false
		%DisconnectButton. disabled = true
		%PingButton.disabled = true


func _on_ping_received(ping: float) -> void:
	%PingLabel.text = "Ping = %.2fms" % ping
