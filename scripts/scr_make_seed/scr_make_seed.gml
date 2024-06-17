function scr_make_seed() {
	randomise();
	return irandom_range(1, $7FffFFff);
}