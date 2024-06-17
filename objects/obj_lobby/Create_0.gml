ready = [false, false];
start_in = 0;
start_acc = 0;
begin_countdown = function() {
	start_in = 3;
	var b = scr_packet_start(PacketType.StartIn);
	buffer_write(b, buffer_s32, start_in);
	scr_packet_send(b);
}