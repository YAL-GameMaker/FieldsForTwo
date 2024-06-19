net_adapter.update();
if (net_adapter.is_active && net_adapter.is_connected) {
	if (ping_timer == 0) ping_timer = current_time;
	var _timeout = 7;
	if (net_adapter.packets_received < 3) {
		// longer grace period for first packets because of NAT traversal
		_timeout = 20;
	}
	if (current_time > ping_timer + _timeout * 1000) {
		trace("Timed out!");
		net_adapter.reset();
	}
} else {
	ping_timer = 0;
}