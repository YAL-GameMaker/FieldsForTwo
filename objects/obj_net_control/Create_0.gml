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
}

if (steam_initialised() && autotest == 0) {
	change_adapter(new SteamAdapter());
} else {
	change_adapter(new TcpAdapter());
}
ping = 0;
ping_timer = 0;