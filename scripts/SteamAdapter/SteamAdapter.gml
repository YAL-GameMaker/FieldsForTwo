/**
	This adapter wraps Steamworks P2P SDK!
	Host configuration: (lobby_type: steam_lobby_type_*)
	Join configuration: (lobby_id: int64)
**/
function SteamAdapter() : NetworkAdapter() constructor {
	kind = "Steam";
	/**
		This is whomever that we'll be talking to.
		For the server, this is the connected client.
		For the client, this is the server (lobby owner).
	**/
	remote = 0;
	buffer = buffer_create(1024, buffer_grow, 1);
	steam_net_packet_set_type(steam_net_packet_type_reliable);
	
	static __NetworkAdapter_destroy = destroy;
	static destroy = function() {
		__NetworkAdapter_destroy();
		buffer_delete(buffer);
	}
	
	static __NetworkAdapter_reset = reset;
	static reset = function() {
		__NetworkAdapter_reset();
		steam_lobby_leave();
		remote = 0;
	}
	
	static __NetworkAdapter_host = host;
	static host = function(_config) {
		__NetworkAdapter_host(_config);
		steam_lobby_create(_config.lobby_type, 2);
	}
	
	static __NetworkAdapter_join = join;
	static join = function(_endpoint) {
		__NetworkAdapter_join(_endpoint);
		steam_lobby_join_id(_endpoint.lobby_id);
	}
	
	static __NetworkAdapter_update = update;
	static update = function() {
		__NetworkAdapter_update();
		steam_update();
		
		if (remote == 0 && is_server && steam_lobby_get_lobby_id() != 0) {
			// if we're a server, wait for a player to show up
			var n = steam_lobby_get_member_count();
			var _self = steam_get_user_steam_id();
			for (var i = 0; i < n; i++) {
				var _id = steam_lobby_get_member_id(i);
				if (_id != _self) {
					remote = _id;
					handle_connect(true);
				}
			}
		}
		
		while (steam_net_packet_receive()) {
			var _sender = steam_net_packet_get_sender_id();
			if (_sender != remote) {
				trace("Unexpected sender", _sender, "expected", remote);
				continue;
			}
			
			// original Steamworks.gml would resize the buffer for you, remake doesn't:
			var _size = steam_net_packet_get_size();
			if (buffer_get_size(buffer) < _size) {
				buffer_resize(buffer, _size);
				//buffer_set_used_size(buffer, _size);
			}
			steam_net_packet_get_data(buffer);
			//trace("recv", buffer_prettyprint(buffer, _size));
			
			// don't forget to rewind the buffer before reading!
			buffer_seek(buffer, buffer_seek_start, 0);
			handle_packet(buffer, _size);
		}
	}
	
	static send = function(_buf, _size) {
		if (!can_send()) return false;
		if (remote == 0) return false;
		var _ok = steam_net_packet_send(remote, _buf, _size);
		//trace("send remote:", remote, "ok:", _ok, buffer_prettyprint(buffer, _size));
		if (!_ok) {
			trace("Send failed:", _size, "bytes");
			return false;
		}
		return true;
	}
	
	static async_steam = function() {
		var e = async_load;
		switch (async_load[?"event_type"]) {
			case "lobby_created":
				if (is_creating) {
					handle_host(e[?"success"]);
				}
				break;
			case "lobby_joined":
				if (is_connecting) {
					var _ok = e[?"success"];
					if (_ok) {
						remote = steam_lobby_get_owner_id();
					}
					// special case: if you do matchmaking,
					// it's possible for lobby owner to leave by the time you enter it
					/*if (remote == steam_get_user_steam_id()) {
						trace("There's no one else in this lobby!");
						_ok = false;
					}*/
					handle_connect(_ok);
				}
				break;
			case "lobby_join_requested": // can accept invites in the menu
				if (room == rm_menu) {
					join({ lobby_id: e[?"lobby_id"] });
				}
				break;
		}
	}
}