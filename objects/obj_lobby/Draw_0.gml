draw_set_font(fnt_test);
var s = "We're in a lobby!";
if (ready_local) {
	s += "\nYou are ready.";
} else {
	s += "\n[1] Ready up";
}
if (ready_remote) {
	s += "\nThe opponent is ready.";
} else {
	s += "\nThe opponent is not ready.";
}
if (start_in > 0) {
	s += "\nStarting in " + string(start_in);
}
s += "\n[Esc] Exit";

draw_text(5, 5, s);