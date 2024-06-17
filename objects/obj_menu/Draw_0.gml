var s = "";
if (error != "") {
	s = error;
} else if (net_adapter.is_creating) {
	s = "Creating a lobby...";
} else if (net_adapter.is_connecting) {
	s = "Connecting...";
} else if (net_adapter.is_server) {
	s = "Waiting for other player to connect!";
}
draw_set_font(fnt_test);
draw_text(5, 5, s);