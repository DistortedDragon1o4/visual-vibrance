#ifndef SETTINGS_GLSL
#define SETTINGS_GLSL

const float shadowDistance = 64.0;
const int shadowMapResolution = 512;

const bool shadowHardwareFiltering = true;

#define SHADOW_DISTORTION 0.85
#define SHADOW_RADIUS 0.005
#define SHADOW_SAMPLES 4

#define WATER_ABSORPTION vec3(0.3, 0.09, 0.04) * 3.0

#define BLOOM_RADIUS 1.0

#endif // SETTINGS_GLSL