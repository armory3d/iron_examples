#version 450

in vec3 pos;
in vec3 nor;

out vec3 wnormal;

uniform mat3 N;
uniform mat4 WVP;

void main() {
	wnormal = normalize(N * nor);
	gl_Position = WVP * vec4(pos, 1.0);
}
