shader_type particles;

global uniform sampler2D Heightmap;
global uniform sampler2D Densitymap;
global uniform float HeightOffset;
global uniform float HeightScale;
uniform sampler2D normalMap : hint_normal;
uniform float totalParticles = 20.0;
uniform float particleDensity = 1.0;

uniform float uvSampleOff = 0.05; //used for sampling heightmap to calculate areas of density, should read density map


float Hash21(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 randomVec(uint seed)
{

	vec2 outputDir;
	outputDir.x = float(int(seed) * 53 % 101);
	outputDir.y = float(int(seed) * 27 % 13);
	outputDir *= Hash21(outputDir);
	outputDir = fract(outputDir);
	return outputDir;
}
vec2 dir(sampler2D tex, vec2 uv)
{
	vec2 direction = vec2(0.0);
	for(int i = -1; i < 2;i++)
	{
		for(int j = -1; j < 2; j++)
		{
			vec2 uvOffs = vec2(float(i),float(j));
			float read = texture(tex,uv + uvOffs * uvSampleOff).r;
			direction += uvOffs * read;
		}
	}
	return direction/9.0;
}

void start() {
	vec2 uv = vec2(float(INDEX)/totalParticles,float(int(INDEX) % int(totalParticles)))/totalParticles;
	vec2 offset = randomVec(INDEX) * (1.0/totalParticles) * 0.5;
	uv += offset;
	//rotation
	vec3 normal =  texture(normalMap,uv).xyz;
	vec3 tangent = normalize(cross(normal,vec3(0,-1.0,0)));
	vec3 bitangent = normalize(cross(normal,tangent));


	TRANSFORM[0].xyz = tangent;
	TRANSFORM[1].xyz = bitangent;
	TRANSFORM[2].xyz = normal;

	TRANSFORM[3].xz = uv * particleDensity;
	TRANSFORM[3].y = (texture(Heightmap,uv).r + HeightOffset) * HeightScale * 1.0;


	CUSTOM = vec4(normal,0.0);
	COLOR = vec4(uv,0.0,0.0);
}

void process() {
	// Called every frame on existing particles (according to the Fixed FPS property).
}
