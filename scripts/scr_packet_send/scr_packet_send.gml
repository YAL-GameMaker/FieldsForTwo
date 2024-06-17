function scr_packet_send(_buf) {
	var _size = buffer_tell(_buf);
	//trace("[send]", _size);
	return net_adapter.send(_buf, _size);
}