#version 450

in vec3 pos;
in vec3 nor;

out vec4 spos;

uniform mat4 WVP;
uniform float norm;
uniform float twist;

void main() {
	spos = vec4(pos * 1.5, 1.0);
	spos.xyz = spos.xyz * (1.0 - norm) + normalize(spos.xyz) * norm * 1.5;
	spos.xy += sin(spos.z * 10.0) / 4.0 * twist;
	gl_Position = WVP * spos;
}
