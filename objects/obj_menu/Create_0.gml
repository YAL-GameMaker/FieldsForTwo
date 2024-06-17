error = "";
net_adapter.on_host = function(_ok) {
	trace("host", _ok);
	if (!_ok) error = "Failed to create a lobby!";
};
net_adapter.on_connect = function(_ok) {
	trace("connect", _ok);
	if (_ok) {
		with (obj_net_control) {
			ping = 0;
			ping_timer = 0;
		}
		if (net_adapter.is_server) {
			var b = scr_packet_start(PacketType.Ping);
			scr_packet_send(b);
		}
		room_goto_net(rm_lobby);
	} else {
		error = "Failed to connect!";
	}
};

var is_fork = false;
for (var i = 1; i < parameter_count(); i++) {
	var p = parameter_string(i);
	if (p == "--fork") {
		is_fork = true;
		break;
	}
}
if (debug_mode) is_fork = true;
if (!is_fork) {
	net_adapter.host(5394);
} else {
	window_set_position(window_get_x() + window_get_width(), window_get_y());
	net_adapter.join({url: "127.0.0.1", port:5394});
}