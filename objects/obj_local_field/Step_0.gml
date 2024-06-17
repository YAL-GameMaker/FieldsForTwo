if (state != FieldState.Playing) exit;

if (keyboard_check(vk_shift)) {
	turn_timer = min(turn_timer, 0.1);
}
turn_timer -= delta_time_s;
if (turn_timer <= 0) {
	scr_perform_turn({ type: "timer" });
	
	// go faster as heat builds up
	turn_timer = 0.1 + 0.9 / (1 + heat / 10);
}