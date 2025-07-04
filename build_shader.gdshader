shader_type spatial;
uniform float redmulti : hint_range(0.0, 1.0) = 1.0;
uniform float greenmulti : hint_range(0.0, 1.0) = 1.0;
uniform float bluemulti : hint_range(0.0, 1.0) = 1.0;
uniform sampler2D Noise;
uniform float time : hint_range(0.0, 1.0, 0.01);
uniform vec2 dir; // Direction that the Noisemap will scroll to
uniform vec3 emission;
uniform float alpha : hint_range(0.0, 1.0, 0.01);
uniform float freq : hint_range(0.0, 5.0, 0.01) = 1.0;
uniform float amp : hint_range(0.0, 5.0, 0.01) = 3.0;
uniform float offset : hint_range(0.0, 5.0, 0.01) = 2.21;

void fragment() {
	ALBEDO = vec3((1.0-(sin(TIME)*0.5))*redmulti,(1.0-(sin(TIME)*0.5))*greenmulti,(1.0-(sin(TIME)*0.5))*bluemulti);
	ALPHA = 0.6;
	
	vec2 uv = UV;
	vec2 move = dir * time * TIME;
	
	
	EMISSION = ALBEDO;
}
