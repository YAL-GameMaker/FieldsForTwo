seed = 0;
state = FieldState.Playing;
enum FieldState {
	Playing,
	Victory,
	Defeat,
}
points = autotest ? 100 : 0;
heat = 0;
spawn_block = function() {
	var _width = irandom_range(20, 44);
	var _min = x;
	var _max = x + sprite_width - _width;
	with (instance_create_layer(irandom_range(_min, _max), y, "Blocks", obj_falling_block)) {
		image_xscale = _width / sprite_width;
		field = other.id;
		
		// try to not overlap other freshly spawned blocks (but don't try too hard):
		if (place_meeting(x, y, obj_falling_block)) repeat (30) {
			x = irandom_range(_min, _max);
			if (!place_meeting(x, y, obj_falling_block)) break;
		}
	}
}