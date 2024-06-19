/**
	When we switch rooms, we don't want to process further packets until we're in the new room
	(see is_paused in {NetworkAdapter})
**/
function room_goto_net(_room) {
	net_adapter.pause();
	room_goto(_room);
}