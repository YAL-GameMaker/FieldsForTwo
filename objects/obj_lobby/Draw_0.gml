draw_set_font(fnt_test);
var s = "We're in a lobby!";
if (ready[0]) {
	s += "\nYou are ready.";
} else {
	s += "\n[1] Ready up";
}
if (ready[1]) {
	s += "\nThe opponent is ready.";
} else {
	s += "\nThe opponent is not ready.";
}
if (start_in > 0) {
	s += "\nStarting in " + string(start_in);
}

draw_text(5, 5, s);