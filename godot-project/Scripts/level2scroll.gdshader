shader_type canvas_item;
uniform bool paused;
// Not too sure how this works
void vertex() {
	// If not paused, move the backgrounds
	if (paused == false) {
		UV.x += TIME;
		}
	}