function room_goto_net(_room) {
	net_adapter.pause();
	room_goto(_room);
}