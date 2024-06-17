function sleep(_ms) {
	var _till = current_time + _ms;
	while (current_time < _till) {
		// just a busy loop
	}
}