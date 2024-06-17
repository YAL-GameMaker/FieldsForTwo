seed = 0;
state = FieldState.Playing;
enum FieldState {
	Playing,
	Victory,
	Defeat,
}
points = 0;
heat = 0;
spawn_block = function() {
	var _width = irandom_range(20, 44);
	var _x = irandom_range(0, sprite_width - _width);
	with (instance_create_layer(x + _x, y, "Blocks", obj_falling_block)) {
		image_xscale = _width / sprite_width;
		field = other.id;
		
		// try to not overlap other freshly spawned blocks (but don't try too hard):
		if (place_meeting(x, y, obj_falling_block)) repeat (10) {
			x = other.x + irandom_range(0, sprite_width - _width);
			if (!place_meeting(x, y, obj_falling_block)) break;
		}
	}
}