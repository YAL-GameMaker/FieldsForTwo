field = noone;
change = function(_object) {
	var _result = instance_create_layer(x, y, layer, _object);
	with (_result) {
		image_xscale = other.image_xscale;
		field = other.field;
	}
	instance_destroy();
	return _result;
}