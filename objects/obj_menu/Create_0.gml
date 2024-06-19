error = "";
function add_adapter_callbacks() {
	net_adapter.on_host = function(_ok) {
		trace("host", _ok);
		if (!_ok) error = "Failed to create a lobby!";
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
			error = "Failed to connect!";
		}
	};
}
add_adapter_callbacks();

modal = "";
join_ip = "127.0.0.1";
join_port = 5394;
host_port = 5394;

if (autotest != 0) {
	// assume two copies of the game, one of which was ran with --fork argument
	var is_fork = false;
	for (var i = 1; i < parameter_count(); i++) {
		var p = parameter_string(i);
		if (p == "--fork") {
			is_fork = true;
			break;
		}
	}
	if (debug_mode) is_fork = true;
	window_set_position(
		window_get_x() + window_get_width() / 2 * (is_fork ? 1 : -1),
		window_get_y()
	);
	if (autotest < 0) {
		// OK!
	} else if (!is_fork) {
		net_adapter.host({ port: 5394 });
	} else {
		net_adapter.join({
			url: "127.0.0.1",
			port: 5394
		});
	}
}