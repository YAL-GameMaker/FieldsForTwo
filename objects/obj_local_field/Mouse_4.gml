if (state != FieldState.Playing) exit;

scr_perform_turn({
	type: "click",
	x: floor(mouse_x - x),
	y: floor(mouse_y - y),
})