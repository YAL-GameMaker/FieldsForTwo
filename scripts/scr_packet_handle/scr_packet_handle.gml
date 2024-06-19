function scr_packet_handle(_buf, _size) {
	if (_size < 1) exit;
	
	var _type = buffer_read(_buf, buffer_u8);
	/*if (_type != PacketType.Ping) {
		trace("Packet! type:", _type, "size:", _size);
	}*/
	switch (_type) {
		case PacketType.Ping:
			with (obj_net_control) {
				// figure out how long it's been:
				if (ping_timer != 0) {
					ping = current_time - ping_timer;
				}
				
				// and send a ping (pong) back:
				ping_timer = current_time;
				scr_packet_send_simple(PacketType.Ping);
			}
			break;
		case PacketType.Ready:
			with (obj_lobby) {
				if (ready_remote) break;
				ready_remote = true;
				
				if (net_adapter.is_server && ready_local) {
					// if we're the server and both players are ready now, begin the countdown
					with (obj_lobby) begin_countdown();
				}
			}
			break;
		case PacketType.StartIn:
			with (obj_lobby) {
				// update the displayed countdown for the client
				start_in = buffer_read(_buf, buffer_s32);
				break;
			}
			break;
		case PacketType.Start:
			room_goto_net(rm_game);
			break;
		case PacketType.Turn:
			var _str = buffer_read(_buf, buffer_string);
			var _json = json_parse(_str);
			with (obj_remote_field) scr_handle_turn(_json);
			break;
		case PacketType.BackToLobby:
			with (obj_local_field) if (state != FieldState.Playing) {
				room_goto_net(rm_lobby);
			}
			break;
	}
}