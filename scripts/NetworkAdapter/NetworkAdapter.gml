function NetworkAdapter() constructor {
	kind = "?";
	is_active = false;
	is_server = false;
	is_connected = false;
	is_connecting = false;
	is_creating = false;
	
	// callbacks:
	on_host = function(_success) {};
	on_connect = function(_success) {};
	on_disconnect = function() {};
	on_packet = function(_buf, _size) {};
	
	// Main API:
	static reset = function() {
		ds_queue_clear(pause_queue);
		is_active = false;
		is_server = false;
		is_connected = false;
		is_connecting = false;
		is_creating = false;
	};
	static update = function() {};
	static host = function(_port) {
		if (is_active) reset();
		is_active = true;
		is_server = true;
		is_creating = true;
	};
	static join = function(_endpoint) {
		if (is_active) reset();
		is_active = true;
		is_server = false;
		is_connecting = true;
	};
	static can_send = function() {
		if (!is_connected) {
			trace("Can't send, not connected");
			return false;
		}
		return true;
	}
	static send = function(_buf, _size) {
		return false;
	}
	
	/**
		While paused, the incoming packets are queued up.
		This can be handy if we receive a request to change rooms
		(which happens at the end of the frame) followed by packets
		that should apply once we are in that room.
	**/
	is_paused = false;
	pause_queue = ds_queue_create();
	static pause = function() {
		is_paused = true;
	};
	static resume = function() {
		is_paused = false;
		repeat (ds_queue_size(pause_queue)) {
			var _buf = ds_queue_dequeue(pause_queue);
			handle_packet(_buf, buffer_get_size(_buf));
		}
	};
	
	// These are to be called by adapter implementations
	static handle_host = function(_success) {
		if (_success) {
			is_creating = false;
		} else {
			reset();
		}
		on_host(_success);
	}
	static handle_connect = function(_success) {
		is_connecting = false;
		is_connected = _success;
		on_connect(_success);
	};
	static handle_disconnect = function() {
		is_connected = false;
		ds_queue_clear(pause_queue);
		on_disconnect();
	};
	static handle_packet = function(_buf, _size) {
		if (is_paused) {
			var _copy = buffer_create(_size, buffer_fixed, 1);
			buffer_copy(_buf, 0, _size, _copy, 0);
			ds_queue_enqueue(pause_queue, _copy);
			exit;
		}
		on_packet(_buf, _size);
	};
	
	//
	static async_network = function() {};
	static async_steam = function() {};
}