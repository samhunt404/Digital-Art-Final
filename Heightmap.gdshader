shader_type spatial;
uniform sampler2D NormalMap : hint_normal;
uniform vec3 color : source_color;
global uniform sampler2D Heightmap;
global uniform float HeightOffset;
global uniform float HeightScale;

uniform sampler2D colors;
void vertex() {
	VERTEX.y = (texture(Heightmap,UV).r + HeightOffset) * HeightScale;
	NORMAL = texture(NormalMap,UV).rgb;
}

void fragment() {
	ALBEDO = color;
}
