shader_type spatial;
render_mode cull_disabled;
uniform sampler2D sceneNormal;
uniform sampler2D colors;

global uniform sampler2D Heightmap;
global uniform sampler2D Wind;
global uniform vec2 WindDir;
global uniform vec2 WindSpeed;

varying vec3 normalVal;
varying vec2 uv;
void vertex() {
	//uv from particle system
	uv = COLOR.xy;
	vec2 windStren = WindDir * texture(Wind, fract(uv + WindSpeed * TIME)).r * (UV.y);
	VERTEX.xz += (vec4(windStren,0.0,0.0) * MODEL_MATRIX).xy;
	normalVal = INSTANCE_CUSTOM.xyz;
	vec3 local_up = MODEL_MATRIX[1].xyz;
	//cross of:
	//	local_transform.basis.y     and    to_world(view_space.forward)
	//normalized
	//(represents right direction)
	vec4 ax = vec4(normalize(cross(local_up, INV_VIEW_MATRIX[2].xyz)), 0.0);
	//local_transform.basis.y
	//(represents up direction)
	vec4 ay = vec4(local_up.xyz, 0.0);
	//cross of:
	//	to_world(view_space.right)    and    local_transform.basis.y
	//(represents forward direction)
	vec4 az = vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, local_up)), 0.0);
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(ax, ay, az, MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);

}

void fragment()
{
	NORMAL =  (VIEW_MATRIX * vec4(0.0,0.0,1.0,0.0)).rgb;
	ALBEDO = texture(colors,texture(Heightmap,uv).xy).rgb;
}
