/// Parses string to a numeric port or returns error text
/// @returns {string|number}
function scr_validate_port(_port_str) {
	if (string_digits(_port_str) != _port_str) {
		return "Port should only contain numbers";
	}
	
	var _port;
	try {
		_port = real(_port_str);
	} catch (_e) {
		return "Port is not a valid number";
	}
	
	var _min = 1000;
	var _max = 65535;
	if (_port < _min || _port > _max) {
		return "Port should be in " + string(_min) + "-" + string(_max) + " range";
	}
	
	return _port;
}