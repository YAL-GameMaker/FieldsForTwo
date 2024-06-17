/// @self {obj_field}
function scr_handle_turn(_input) {
	//trace("turn", object_get_name(object_index), _input);
	random_set_seed(_input.seed);
	var _field_id = id;
	switch (_input.type) {
		case "init":
			seed = _input.seed;
			break;
		case "timer":
			var _found = false;
			with (obj_falling_block) if (field == _field_id) {
				_found = true;
				var _ny = y + 32;
				if (!place_meeting(x, _ny, obj_solid_block)
					&& place_meeting(x, _ny, field)
				) {
					y = _ny;
				} else {
					if (y < other.y + 32) {
						other.state = FieldState.Defeat;
						with (obj_field) if (id != _field_id) {
							if (state == FieldState.Playing) {
								state = FieldState.Victory;
							}
						}
					}
					solidify();
				}
			}
			if (!_found) {
				spawn_block();
			}
			break;
		case "click":
			heat += 1;
			var _block = instance_position(
				x + _input.x,
				y + _input.y,
				obj_block
			);
			if (_block) {
				var _falling = _block.object_index == obj_falling_block;
				if (_falling) {
					// catching blocks mid-air grants two points
					points += 2;
				} else {
					points += 1;
				}
				
				// destroy the block
				instance_destroy(_block);
				
				// and make other blocks fall if there's nothing below them now
				if (!_falling) with (obj_solid_block) if (field == _field_id
					&& !place_meeting(x, y + 1, obj_solid_block)
					&& place_meeting(x, y + 32, obj_field)
				) desolidify();
			}
			break;
		case "attack":
			var _cost = 3;
			if (points < _cost) break;
			points -= _cost;
			
			if (object_index == obj_remote_field) with (obj_local_field) {
				// if it's us that are being attacked, process the attack
				scr_perform_turn({
					type: "attacked",
					attack: _input.attack
				})
			}
			break;
		case "attacked":
			var _attack = _input.attack;
			switch (_attack.type) {
				case "extra":
					repeat (2) spawn_block();
					break;
			}
			break;
	}
}