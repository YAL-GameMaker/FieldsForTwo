error = "";

modal = "";
join_ip = "127.0.0.1";
join_port = 5394;
host_port = 5394;
autotest_pos = 0;

if (autotest) {
	autotest_pos = -1;
	window_set_position(
		window_get_x() - window_get_width() / 2,
		window_get_y()
	);
	net_adapter.host({ port: 5394 });
}