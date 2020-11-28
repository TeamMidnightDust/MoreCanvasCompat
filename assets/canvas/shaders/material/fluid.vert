#include frex:shaders/api/vertex.glsl
#include frex:shaders/api/world.glsl
#include frex:shaders/lib/math.glsl
#include frex:shaders/lib/noise/noise4d.glsl

/******************************************************
  canvas:shaders/material/water.vert

  Based on "GPU-Generated Procedural Wind Animations for Trees"
  by Renaldas Zioma in GPU Gems 3, 2007
  https://developer.nvidia.com/gpugems/gpugems3/part-i-geometry/chapter-6-gpu-generated-procedural-wind-animations-trees
******************************************************/

#define NOISE_SCALE 0.125

void frx_startVertex(inout frx_VertexData data) {
	#ifdef ANIMATED_FOLIAGE
	float rain = frx_rainGradient();
	float globalWind = 0.3;

	// wind gets stronger higher in the world
	globalWind *= (0.5 + smoothstep(64.0, 255.0, data.vertex.y));

	float t = frx_renderSeconds() * 0.05;

	vec3 pos = (data.vertex.xyz + frx_modelOriginWorldPos()) * NOISE_SCALE;
	float wind = snoise(vec4(pos, t)) * globalWind;

	data.vertex.x += sin(t * 4) * wind * 0.3;
	data.vertex.y += (cos(t) * cos(t * 3) * cos(t * 5) * cos(t * 7) + sin(t * 25)) * wind;
	data.vertex.z += sin(t * 4) * wind * 0.3;
	#endif
}
