/*
    Copyright (c) 2024 Josh Britain (jbritain)
    Licensed under the MIT license

      _____   __   _                          
     / ___/  / /  (_)  __ _   __ _  ___   ____
    / (_ /  / /  / /  /  ' \ /  ' \/ -_) / __/
    \___/  /_/  /_/  /_/_/_//_/_/_/\__/ /_/   
    
    By jbritain
    https://jbritain.net
                                            
*/

#include "/lib/common.glsl"
#include "/lib/shadowSpace.glsl"

#ifdef vsh
    #include "/lib/sway.glsl"

    in vec2 mc_Entity;
    in vec4 at_tangent;
    in vec3 at_midBlock;

    out vec2 lmcoord;
    out vec2 texcoord;
    out vec4 glcolor;
    out vec3 normal;
    flat out int materialID;
    out vec3 feetPlayerPos;
    out vec3 shadowViewPos;

    void main() {        
        texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
        lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
        glcolor = gl_Color;
        normal = gl_NormalMatrix * gl_Normal; // shadow view space

        materialID = int(mc_Entity.x + 0.5);

        shadowViewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
        #ifdef WAVING_BLOCKS
        feetPlayerPos = (shadowModelViewInverse * vec4(shadowViewPos, 1.0)).xyz;
        feetPlayerPos = getSway(materialID, feetPlayerPos + cameraPosition, at_midBlock) - cameraPosition;
        shadowViewPos = (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
        #endif
        gl_Position = gl_ProjectionMatrix * vec4(shadowViewPos, 1.0);

        
        gl_Position.xyz = distort(gl_Position.xyz);
    }

#endif

// ===========================================================================================

#ifdef fsh
    in vec2 lmcoord;
    in vec2 texcoord;
    in vec4 glcolor;
    in mat3 tbnMatrix;
    flat in int materialID;
    in vec3 shadowViewPos;
    in vec3 feetPlayerPos;

    #include "/lib/dh.glsl"
    #include "/lib/lighting/shading.glsl"
    #include "/lib/water/waterFog.glsl"
    #include "/lib/water/waveNormals.glsl"

    /* RENDERTARGETS: 0 */
    layout(location = 0) out vec4 color;

    void main() {
        color = texture(gtexture, texcoord) * glcolor;

        if (color.a < alphaTestRef) {
            discard;
        }

        const float avgWaterExtinction = sum3(waterExtinction) / 3.0;

        if(materialID == MATERIAL_WATER){
            float opaqueDepth = texture(shadowtex1, gl_FragCoord.xy / shadowMapResolution).r;
            float opaqueDistance = getShadowDistanceZ(opaqueDepth); // how far away from the sun is the opaque fragment shadowed by the water?
            float waterDepth = abs(shadowViewPos.z - opaqueDistance);

            color.rgb = 1.0 - waterExtinction;
            color.a = 1.0 - (exp(-avgWaterExtinction * waterDepth));

            #ifdef CAUSTICS
                vec3 waveNormal = waveNormal(feetPlayerPos.xz + cameraPosition.xz, vec3(0.0, 1.0, 0.0), 1.0);
                vec3 refracted = refract(-worldLightDir, waveNormal, 1.0/1.33);

                vec3 oldPos = feetPlayerPos - worldLightDir * waterDepth;
                vec3 newPos = feetPlayerPos + refracted * waterDepth;

                float oldArea = length(dFdx(oldPos)) * length(dFdy(oldPos));
                float newArea = length(dFdx(newPos)) * length(dFdy(newPos));
                color.a *= (1.0 - oldArea / newArea);
            #endif
            
        }

        color.rgb = pow(color.rgb, vec3(2.2));
    }

#endif