/// A shortcut for sending a single-byte packet.
function scr_packet_send_simple(_type) {
	var b = scr_packet_start(_type);
	return scr_packet_send(b);
}
