function scr_perform_turn(_input) {
	_input.seed = scr_make_seed();
	if (net_adapter.is_active) {
		var _str = json_stringify(_input);
		var b = scr_packet_start(PacketType.Turn);
		buffer_write(b, buffer_string, _str);
		scr_packet_send(b);
		
		// parse it back just in case it contains something that changes after de-serialization
		_input = json_parse(_str);
	}
	scr_handle_turn(_input);
}