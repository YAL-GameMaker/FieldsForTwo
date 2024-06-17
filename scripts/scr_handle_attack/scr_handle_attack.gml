function scr_handle_attack(_attack) {
	scr_perform_turn({
		type: "attacked",
		attack: _attack,
	})
}