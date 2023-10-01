#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>
#moj_import <slightlylessfancypants_config.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform float GameTime;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 dyeColor;
out vec4 lightColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec4 normal;
out vec2 overlayUv;
out vec2 interpolationUv;
out vec2 emissiveUv;
out vec2 interpolationEmissiveUv;
out float frameProgress;

int toInt(vec3 c) {
    ivec3 v = ivec3(round(c*255.0));
    return (v.r<<16)+(v.g<<8)+v.b;
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    lightColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(1.0)) * texelFetch(Sampler2, UV2 / 16, 0);
    dyeColor = Color;
    texCoord0 = UV0;
    texCoord1 = UV1;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);

    const ivec2 armorSize = ivec2(TEX_RES * 4, TEX_RES * 2);
    ivec2 texSize = ivec2(textureSize(Sampler0, 0));
    vec2 armorScale = vec2(armorSize) / vec2(texSize);
    vec2 localUv = armorScale * UV0;

    frameProgress = 0.0;
    overlayUv = emissiveUv = interpolationUv = vec2(-1.0);

    if (texSize.y != armorSize.y) {
        // weird texture size, must be our leather armor texture
        ivec2 armorsetPos = ivec2((toInt(Color.rgb) + 1) * armorSize.x, 0);

        if (armorsetPos.x < texSize.x) {
            // custom armor
            ivec4 animationInfo = ivec4(round(texelFetch(Sampler0, armorsetPos + ivec2(1, 0), 0) * 255.0));
            ivec4 emissiveInfo  = ivec4(round(texelFetch(Sampler0, armorsetPos + ivec2(2, 0), 0) * 255.0));

            if(animationInfo.a == 255) {
                // animated
                float frame = GameTime * animationInfo.g * ANIM_SPEED;
                int currentFrame = int(frame) % animationInfo.r;
                int nextFrame = (currentFrame + 1) % animationInfo.r;

                if(animationInfo.b > 0) {
                    // interpolated frames
                    interpolationUv = localUv + (armorsetPos + ivec2(0, armorSize.y) * nextFrame) / vec2(texSize);
                    frameProgress = fract(frame);
                }
                
                armorsetPos.y += armorSize.y * currentFrame;
            }
            
            texCoord0 = localUv + armorsetPos / vec2(texSize);
            dyeColor = vec4(1.0);

            if(emissiveInfo.a == 255) {
                if(emissiveInfo.r == 1) {
                    // emissive map
                    emissiveUv = texCoord0 + vec2(armorScale.x, 0.0);
                    interpolationEmissiveUv = interpolationUv + vec2(armorScale.x, 0.0);
                } else if(emissiveInfo.r > 1) {
                    // fully emissive
                    lightColor = vec4(1.0);
                }
            }
        } else {
            // vanilla armor
            overlayUv = armorScale * UV0 + vec2(0.0, armorScale.y);
            texCoord0 = armorScale * UV0;
        }

    }
}
