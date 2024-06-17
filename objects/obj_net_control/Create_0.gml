globalvar net_adapter; /// @is {NetworkAdapter}
net_adapter = new TcpAdapter();
net_adapter.on_disconnect = function() {
	trace("Disconnected!");
}
net_adapter.on_packet = function(_buf, _size) {
	scr_packet_handle(_buf, _size);
}
ping = 0;
ping_timer = 0;