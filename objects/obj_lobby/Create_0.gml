ready = [false, false];
ready_local = false;
ready_remote = false;
start_in = 0;
start_acc = 0;
begin_countdown = function() {
	start_in = autotest ? 1 : 3;
	var b = scr_packet_start(PacketType.StartIn);
	buffer_write(b, buffer_s32, start_in);
	scr_packet_send(b);
}