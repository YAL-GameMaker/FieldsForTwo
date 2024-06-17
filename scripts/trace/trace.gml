/// @description  trace(...)
/// @param ...
function trace() {
	var r = string(current_time);
	for (var i = 0; i < argument_count; i++) {
	    r += " " + string(argument[i]);
	}
	show_debug_message(r);
}
