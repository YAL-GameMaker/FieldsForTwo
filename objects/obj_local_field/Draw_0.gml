event_inherited();

var _text = "";
switch (state) {
	case FieldState.Victory:
		_text = "You won!";
		break;
	case FieldState.Defeat:
		_text = "You lost!";
		break;
}
if (state != FieldState.Playing && net_adapter.is_server) {
	_text += "\n[Enter] Back to lobby";
} else {
	_text += "\n[Esc] Exit";
}

var _halign = draw_get_halign();
draw_set_halign(fa_right);
draw_text(x + sprite_width, y + sprite_height + 5, _text);
draw_set_halign(_halign);