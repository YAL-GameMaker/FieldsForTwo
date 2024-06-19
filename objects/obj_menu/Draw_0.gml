var s = "";
if (error != "") {
	s = error;
	s += "\n[Esc] Back";
	if (keyboard_check_pressed(vk_escape)) {
		error = "";
	}
} else if (net_adapter.is_creating) {
	s = "Creating a lobby...";
} else if (net_adapter.is_connecting) {
	s = "Connecting...";
} else if (net_adapter.is_server) {
	s = "Waiting for other player to connect!";
	s += "\n[Esc] Cancel";
	
	if (keyboard_check_pressed(vk_escape)) {
		net_adapter.reset();
	}
}
else if (modal == "host_port" || modal == "join_port") {
	s = "Port: " + keyboard_string + "_";
	s += "\n[Enter] Confirm";
	s += "\n[Esc] Back"
	if (keyboard_check_pressed(vk_enter)) {
		var _port = scr_validate_port(keyboard_string);
		if (is_string(_port)) {
			show_message(_port);
		} else {
			if (modal == "host_port") {
				host_port = _port;
				net_adapter.host({ port: _port });
			} else {
				join_port = _port;
				net_adapter.join({ url: join_ip, port: join_port });
			}
			modal = "";
		}
	} else if (keyboard_check_pressed(vk_escape)) {
		modal = "";
	}
}
else if (modal == "join_ip") {
	s = "IP: " + keyboard_string + "_";
	s += "\n[Enter] Confirm";
	s += "\n[Esc] Back";
	if (keyboard_check_pressed(vk_enter)) {
		join_ip = keyboard_string;
		modal = "join_port";
		keyboard_string = string(join_port);
	} else if (keyboard_check_pressed(vk_escape)) {
		modal = "";
	}
}
else {
	var _steam = net_adapter.kind == "Steam";
	var _can_steam = steam_initialised();
	s = "Menu:";
	
	s += "\n[1] Host";
	if (keyboard_check_pressed(ord("1"))) {
		if (_steam) {
			net_adapter.host({
				lobby_type: steam_lobby_type_friends_only
			});
		} else {
			modal = "host_port";
			keyboard_string = string(host_port);
		}
	}
	
	s += "\n[2] " + (_steam ? "Show overlay" : "Join");
	if (keyboard_check_pressed(ord("2"))) {
		if (_steam) {
			steam_activate_overlay(ov_friends);
		} else {
			modal = "join_ip";
			keyboard_string = join_ip;
		}
	}
	
	s += "\n[3] " + (_can_steam
		? "Change adapter (currently: " + net_adapter.kind + ")"
		: "(Steam is unavailable!)"
	);
	if (keyboard_check_pressed(ord("3")) && _can_steam) {
		var _adapter;
		if (_steam) {
			_adapter = new TcpAdapter();
		} else {
			_adapter = new SteamAdapter();
		}
		with (obj_net_control) change_adapter(_adapter);
	}
}
draw_set_font(fnt_test);
draw_text(5, 5, s);