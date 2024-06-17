function call_soon(_func) {
	call_later(1, time_source_units_frames, _func);
}