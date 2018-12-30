#version 450

in vec4 pos;

uniform mat4 WVP;

void main() {
	gl_Position = WVP * vec4(pos.xyz, 1.0);
}
