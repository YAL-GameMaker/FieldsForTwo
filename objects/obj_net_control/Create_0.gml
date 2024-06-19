globalvar net_adapter; /// @is {NetworkAdapter}
net_adapter = undefined;

change_adapter = function(_net_adapter) {
	if (net_adapter != undefined) {
		net_adapter.destroy();
	}
	net_adapter = _net_adapter;
	
	// and bind the callbacks!
	net_adapter.on_disconnect = function() {
		trace("Disconnected!");
	}
	net_adapter.on_packet = function(_buf, _size) {
		scr_packet_handle(_buf, _size);
	}
	net_adapter.on_host = function(_ok) {
		trace("host", _ok);
		if (!_ok) with (obj_menu) {
			if (autotest && autotest_pos < 0) {
				// move the now-client window to the right instead
				autotest_pos = 1;
				window_set_position(
					window_get_x() + window_get_width(),
					window_get_y()
				);
				net_adapter.join({
					url: "127.0.0.1",
					port: 5394
				});
			} else error = "Failed to create a lobby!";
		}
	};
	net_adapter.on_connect = function(_ok) {
		trace("connect", _ok);
		if (_ok) {
			// reset ping metrics and send the first ping:
			with (obj_net_control) {
				ping = 0;
				ping_timer = current_time;
			}
			if (net_adapter.is_server) {
				scr_packet_send_simple(PacketType.Ping);
			}
			room_goto_net(rm_lobby);
		} else {
			with (obj_menu) error = "Failed to connect!";
		}
	};
}

if (steam_initialised() && autotest == 0) {
	change_adapter(new SteamAdapter());
} else {
	change_adapter(new TcpAdapter());
}
ping = 0;
ping_timer = 0;