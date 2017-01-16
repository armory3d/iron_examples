#version 450

in vec3 wnormal;

out vec4 fragColor;

uniform vec3 lightColor;
uniform vec3 lightDir;
uniform vec3 color;

void main() {
	vec3 n = normalize(wnormal);
	vec3 l = lightDir;
	float dotNL = dot(n, l);
	
	vec3 direct = color * max(0.0, dotNL);
	vec3 indirect = vec3(0.3, 0.1, 0.1);
	
	fragColor = vec4(direct * lightColor + indirect, 1.0);
}
