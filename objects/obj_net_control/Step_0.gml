net_adapter.update();
if (net_adapter.is_active) {
	if (current_time > ping_timer + 7000) {
		trace("Timed out!");
		net_adapter.reset();
	}
}