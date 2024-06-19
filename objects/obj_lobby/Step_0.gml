if (!ready_local && (keyboard_check_pressed(ord("1")) || autotest)) {
	ready_local = true;
	scr_packet_send_simple(PacketType.Ready);
	
	if (net_adapter.is_server && ready_remote) {
		begin_countdown();
	}
}
if (start_in > 0 && net_adapter.is_server) {
	start_acc += delta_time_s;
	if (start_acc > 1) {
		start_acc = 0;
		start_in -= 1;
		
		var b = scr_packet_start(PacketType.StartIn);
		buffer_write(b, buffer_s32, start_in);
		scr_packet_send(b);
		
		if (start_in == 0) {
			scr_packet_send_simple(PacketType.Start);
			sleep(obj_net_control.ping / 2);
			room_goto_net(rm_game);
		}
	}
}
if (keyboard_check_pressed(vk_escape)) {
	net_adapter.reset();
	room_goto_net(rm_menu);
}