#version 450

in vec4 pos;

void main() {
	gl_Position = vec4(pos.xyz, 1.0);
}
