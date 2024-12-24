#ifndef UNIFORMS_GLSL
#define UNIFORMS_GLSL

// uniform list from Complementary
// https://github.com/ComplementaryDevelopment/ComplementaryReimagined/blob/main/shaders/lib/uniforms.glsl

/*----------------------------------------------------------------------------------------------
        _____                                                                    _____
        ( ___ )                                                                  ( ___ )
        |   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|   |
        |   | ██╗   ██╗███╗   ██╗██╗███████╗ ██████╗ ██████╗ ███╗   ███╗███████╗ |   |
        |   | ██║   ██║████╗  ██║██║██╔════╝██╔═══██╗██╔══██╗████╗ ████║██╔════╝ |   |
        |   | ██║   ██║██╔██╗ ██║██║█████╗  ██║   ██║██████╔╝██╔████╔██║███████╗ |   |
        |   | ██║   ██║██║╚██╗██║██║██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║╚════██║ |   |
        |   | ╚██████╔╝██║ ╚████║██║██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████║ |   |
        |   |  ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ |   |
        |___|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|___|
        (_____)                              (thanks to isuewo and SpacEagle17)  (_____)

---------------------------------------------------------------------------------------------*/

uniform float alphaTestRef;

uniform int blockEntityId;
uniform int currentRenderedItemId;
uniform int entityId;
uniform int frameCounter;
uniform int heldBlockLightValue;
uniform int heldBlockLightValue2;
uniform int heldItemId;
uniform int heldItemId2;
uniform int isEyeInWater;
uniform int moonPhase;
uniform int worldTime;
uniform int worldDay;
uniform int renderStage;

uniform float aspectRatio;
uniform float blindness;
uniform float darknessFactor;
uniform float darknessLightFactor;
uniform float maxBlindnessDarkness;
uniform float eyeAltitude;
uniform float frameTime;
uniform float frameTimeCounter;
uniform float far;
uniform float near;
uniform float nightVision;
uniform float rainStrength;
uniform float screenBrightness;
uniform float viewHeight;
uniform float viewWidth;
vec2 resolution = vec2(viewWidth, viewHeight);
uniform float wetness;
uniform float sunAngle;
uniform float playerMood;

uniform ivec2 atlasSize;
uniform ivec2 eyeBrightness;
uniform ivec2 eyeBrightnessSmooth;

vec2 EB = vec2(eyeBrightness) / 240.0;
vec2 EBS = vec2(eyeBrightnessSmooth) / 240.0;

uniform vec3 cameraPosition;
uniform vec3 fogColor;
uniform vec3 previousCameraPosition;
uniform vec3 skyColor;
uniform vec3 relativeEyePosition;

uniform vec3 sunPosition;
uniform vec3 shadowLightPosition;

uniform vec4 entityColor;
uniform vec4 lightningBoltPosition;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;
uniform sampler2D colortex7;
uniform sampler2D colortex8;
uniform sampler2D colortex9;
uniform sampler2D colortex10;
uniform sampler2D colortex11;
uniform sampler2D colortex12;
uniform sampler2D colortex13;
uniform sampler2D colortex14;
uniform sampler2D colortex15;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D depthtex2;
uniform sampler2D normals;
uniform sampler2D noisetex;
uniform sampler2D specular;
uniform sampler2D gtexture;

uniform ivec3 cameraPositionInt;
uniform ivec3 previousCameraPositionInt;
uniform vec3 cameraPositionFract;
uniform vec3 previousCameraPositionFract;

uniform sampler2D shadowtex1;
uniform sampler2D shadowtex0;
uniform sampler2DShadow shadowtex1HW;
uniform sampler2DShadow shadowtex0HW;

uniform sampler2D shadowcolor0;

uniform sampler2D sunTransmittanceLUTTex;
uniform sampler2D multipleScatteringLUTTex;
uniform sampler2D skyViewLUTTex;

uniform sampler2D perlinNoiseTex;

#ifdef DISTANT_HORIZONS
    uniform int dhRenderDistance;

    uniform mat4 dhProjection;
    uniform mat4 dhProjectionInverse;
    
    uniform sampler2D dhDepthTex;
    uniform sampler2D dhDepthTex1;
#endif

#endif // UNIFORMS_GLSL