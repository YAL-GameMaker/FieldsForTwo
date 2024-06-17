//draw_self();
draw_sprite_stretched(sprite_index, image_index, x - 4, y - 4, sprite_width + 8, sprite_height + 8);
draw_text(
	x, y + sprite_height + 5,
	"Points: " + string(points)
	+ "\nHeat: " + string(heat)
);
