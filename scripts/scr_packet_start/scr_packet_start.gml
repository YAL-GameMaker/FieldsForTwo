function scr_packet_start(_type) {
	static __buf = buffer_create(1024, buffer_grow, 1);
	var _buf = __buf;
	buffer_seek(_buf, buffer_seek_start, 0);
	buffer_write(_buf, buffer_u8, _type);
	return _buf;
}