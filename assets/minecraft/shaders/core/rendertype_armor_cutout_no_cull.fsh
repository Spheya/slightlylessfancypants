#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 dyeColor;
in vec4 lightColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec4 normal;
in vec2 overlayUv;
in vec2 interpolationUv;
in vec2 emissiveUv;
in vec2 interpolationEmissiveUv;
in float frameProgress;

out vec4 fragColor;

void main() {
    vec4 light = lightColor;
    if(emissiveUv.x > 0.0) {
        vec4 sample = mix(texture(Sampler0, emissiveUv), texture(Sampler0, interpolationEmissiveUv), frameProgress);
        light = mix(lightColor, vec4(1.0), sample.r * sample.a);
    }
    
    vec4 color = mix(texture(Sampler0, texCoord0), texture(Sampler0, interpolationUv), frameProgress) * dyeColor * light * ColorModulator;
    
    if(overlayUv.x > 0.0) {
        vec4 overlay = texture(Sampler0, overlayUv) * lightColor * ColorModulator;
        color = mix(color, overlay, overlay.a);
    }

    if (color.a < 0.1) {
        discard;
    }

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
