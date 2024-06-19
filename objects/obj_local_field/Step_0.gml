if (state == FieldState.Playing) {
	if (keyboard_check(vk_shift)) {
		turn_timer = min(turn_timer, 0.1);
	}
	turn_timer -= delta_time_s;
	if (turn_timer <= 0) {
		scr_perform_turn({ type: "timer" });
		
		// go faster as heat builds up
		turn_timer = 0.1 + 0.9 / (1 + heat / 10);
	}
} else {
	if (net_adapter.is_server && keyboard_check_pressed(vk_enter)) {
		scr_packet_send_simple(PacketType.BackToLobby);
		room_goto_net(rm_lobby);
	}
	if (keyboard_check_pressed(vk_escape)) {
		net_adapter.reset();
		room_goto_net(rm_menu);
	}
}
