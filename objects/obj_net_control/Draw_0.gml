draw_set_font(fnt_test);
if (net_adapter.is_connected) {
	var s = net_adapter.is_server ? "Server" : "Client";
	if (ping > 0) {
		s += "\nPing: " + string(ping) + "ms";
	}
	var _ha = draw_get_halign();
	draw_set_halign(fa_right);
	draw_text(room_width - 5, 5, s);
	draw_set_halign(_ha)
}