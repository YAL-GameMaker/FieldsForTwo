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
			// a little extra legwork because the bottom blocks should process first,
			// else a block above can move into a block that's about to solidify
			var _queue = global.__scr_handle_turn__queue;
			ds_priority_clear(_queue);
			with (obj_falling_block) if (field == _field_id) {
				ds_priority_add(_queue, id,
					(y - field.y) * 1000 + (x - field.x)
				);
			}
			
			var _count = ds_priority_size(_queue);
			if (_count == 0) {
				// no falling blocks - make one
				spawn_block();
			} else repeat (_count) with (ds_priority_delete_max(_queue)) {
				var _ny = y + 32;
				// we can keep falling until we hit another block or field boundary
				if (!place_meeting(x, _ny, obj_solid_block)
					&& place_meeting(x, _ny, field)
				) {
					y = _ny;
				} else {
					if (y < other.y + 32) {
						// piled up to the top!
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
				if (!_falling) repeat (16) {
					// we can do this several times if you are removing a block
					// from the bottom of a big tower
					var _new = false;
					with (obj_solid_block) if (field == _field_id
						&& !place_meeting(x, y + 1, obj_solid_block)
						&& place_meeting(x, y + 32, obj_field)
					) {
						_new = true;
						desolidify();
					}
					if (!_new) break;
				}
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
global.__scr_handle_turn__queue = ds_priority_create();