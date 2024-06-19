if (state != FieldState.Playing) exit;

// click remote field to attack
scr_perform_attack({
	type: "extra",
});