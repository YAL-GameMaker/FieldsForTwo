function scr_perform_attack(_attack) {
	with (obj_local_field) scr_perform_turn({
		type: "attack",
		attack: _attack
	});
}