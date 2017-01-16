#version 450

in vec4 spos;

out vec4 fragColor;

uniform vec3 lightColor;
uniform vec3 lightDir;
uniform vec3 color;

void main() {
	vec3 n = normalize(cross(dFdx(spos.xyz), dFdy(spos.xyz)));
	vec3 l = lightDir;
	float dotNL = dot(n, l);
	vec3 direct = color * max(0.0, dotNL) + color * 0.2;
	vec3 indirect = vec3(0.15, 0.15, 0.15);
	fragColor = vec4(direct * lightColor + indirect, 1.0);
}
