#version 150

uniform sampler2D Sampler0;

in vec3 Position;
in vec4 Color;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexColor = Color;
    texCoord0 = UV0;

    //we assume if x >= 2y it is an armor and divide uv
    //cannot pass tint color here so it's the only option
    vec2 size = textureSize(Sampler0, 0);
    if (size.x >= 2*size.y && size.y < 1024) {
        texCoord0 *= vec2(64.0, 32.0) / size;
    }
}