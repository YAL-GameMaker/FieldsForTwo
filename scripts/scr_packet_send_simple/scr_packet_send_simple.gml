function scr_packet_send_simple(_type) {
	var b = scr_packet_start(_type);
	return scr_packet_send(b);
}
