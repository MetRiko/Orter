shader_type canvas_item;

uniform float zoom = 1.0;
uniform float wiggle = 1.0;

void vertex() {
	UV = UV * zoom + (1.0 - zoom) * 0.5;
	UV += vec2(cos(TIME+wiggle)*sin(TIME+wiggle*0.5), sin(TIME+wiggle)*cos(TIME+wiggle*0.5)) * 0.01;
}