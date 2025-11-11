shader_type canvas_item;
uniform bool paused;


void vertex() {
	if (paused == false) {
		UV.y += TIME;
		}
	}
