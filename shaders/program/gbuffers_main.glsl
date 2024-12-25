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

#ifdef vsh

    in vec2 mc_Entity;
    in vec4 at_tangent;

    out vec2 lmcoord;
    out vec2 texcoord;
    out vec4 glcolor;
    out mat3 tbnMatrix;
    flat out int materialID;
    out vec3 viewPos;

    void main() {
        materialID = int(mc_Entity.x + 0.5);
        texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
        lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
        glcolor = gl_Color;

        tbnMatrix[0] = normalize(gl_NormalMatrix * at_tangent.xyz);
        tbnMatrix[2] = normalize(gl_NormalMatrix * gl_Normal);
        tbnMatrix[1] = normalize(cross(tbnMatrix[0], tbnMatrix[2]) * at_tangent.w);

        viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;

        gl_Position = gbufferProjection * vec4(viewPos, 1.0);
    }

#endif

// ===========================================================================================

#ifdef fsh
    #include "/lib/lighting/shading.glsl"
    #include "/lib/util/packing.glsl"
    #include "/lib/lighting/directionalLightmap.glsl"

    in vec2 lmcoord;
    in vec2 texcoord;
    in vec4 glcolor;
    in mat3 tbnMatrix;
    flat in int materialID;
    in vec3 viewPos;

    vec3 getMappedNormal(vec2 texcoord){
        vec3 mappedNormal = texture(normals, texcoord).rgb;
        mappedNormal = mappedNormal * 2.0 - 1.0;
        mappedNormal.z = sqrt(1.0 - dot(mappedNormal.xy, mappedNormal.xy)); // reconstruct z due to labPBR encoding
        
        return tbnMatrix * mappedNormal;
    }

    /* RENDERTARGETS: 0,1 */
    layout(location = 0) out vec4 color;
    layout(location = 1) out vec4 outData1;

    void main() {
        vec2 lightmap = (lmcoord * 33.05 / 32.0) - (1.05 / 32.0);

        #ifdef WORLD_THE_END
        lightmap.y = 1.0;
        #endif

        #ifdef DYNAMIC_HANDLIGHT
            vec3 playerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
            float dist = length(playerPos);
            lightmap.x = max(lightmap.x, (1.0 - clamp01(smoothstep(0.0, 15.0, dist))) * max(heldBlockLightValue, heldBlockLightValue2) / 15.0);
        #endif


        vec4 albedo = texture(gtexture, texcoord) * glcolor;

        if (albedo.a < alphaTestRef) {
            discard;
        }

        albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);

        albedo.rgb = pow(albedo.rgb, vec3(2.2));

        vec3 mappedNormal = getMappedNormal(texcoord);

        vec4 specularData = texture(specular, texcoord);
        Material material = materialFromSpecularMap(albedo.rgb, specularData);
        material.ao = texture(normals, texcoord).z;

        if(materialID == MATERIAL_PLANTS || materialID == MATERIAL_LEAVES){
            material.sss = 1.0;
            material.f0 = vec3(0.04);
            material.roughness = 0.5;
        }

        if(materialID == MATERIAL_WATER){
            material.f0 = vec3(0.02);
            material.roughness = 0.0;
        }

        #ifdef DIRECTIONAL_LIGHTMAPS
        applyDirectionalLightmap(lightmap, viewPos, mappedNormal, tbnMatrix, material.sss);
        #endif

        if(materialID == MATERIAL_WATER){
            color.a = 0.0;
        }  else {
            color.rgb = getShadedColor(material, mappedNormal, tbnMatrix[2], lightmap, viewPos);
            color.a = albedo.a;
            float fresnel = maxVec3(schlick(material, dot(mappedNormal, normalize(-viewPos))));
            color.a *= (1.0 - fresnel);
        }

        outData1.xy = encodeNormal(mat3(gbufferModelViewInverse) * mappedNormal);
        outData1.z = lightmap.y;
        outData1.a = clamp01(float(materialID - 1000) * rcp(255.0));
    }

#endif