#version 450

in vec3 pos;
in vec3 nor;

out vec3 wnormal;

uniform mat4 N;
uniform mat4 WVP;

void main() {
	vec4 spos = vec4(pos, 1.0);
	wnormal = normalize(mat3(N) * nor);
	gl_Position = WVP * spos;
}
