function scr_packet_handle(_buf, _size) {
	if (_size < 1) exit;
	
	var _type = buffer_read(_buf, buffer_u8);
	//if (_type != PacketType.Ping) trace("Packet! type:", _type, "size:", _size);
	switch (_type) {
		case PacketType.Ping:
			with (obj_net_control) {
				// figure out how long it's been:
				if (ping_timer != 0) {
					ping = current_time - ping_timer;
				}
				// and send a ping (pong) back:
				ping_timer = current_time;
				var b = scr_packet_start(PacketType.Ping);
				scr_packet_send(b);
			}
			break;
		case PacketType.Ready:
			with (obj_lobby) {
				if (ready[1]) break;
				ready[1] = true;
				if (net_adapter.is_server && ready[0]) {
					with (obj_lobby) {
						begin_countdown();
					}
				}
			}
			break;
		case PacketType.StartIn:
			with (obj_lobby) {
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
	}
}