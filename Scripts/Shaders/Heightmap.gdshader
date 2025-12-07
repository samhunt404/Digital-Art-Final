shader_type spatial;
uniform sampler2D NormalMap : hint_normal;
global uniform sampler2D Heightmap;
global uniform float HeightOffset;
global uniform float HeightScale;

uniform sampler2D colors;
void vertex() {
	VERTEX.y = (texture(Heightmap,UV).r + HeightOffset) * HeightScale;
}

void fragment() {
	//NORMAL_MAP = texture(NormalMap,UV).rgb;
	ALBEDO = texture(colors,texture(Heightmap,UV).xy).rgb;
}
