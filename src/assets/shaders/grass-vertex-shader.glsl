uniform float grassHeight;
uniform float grassWidth;
uniform int grassVertices;
uniform int grassSegments;
uniform float grassPatchSize;
uniform float time;

#include "./utils/common.glsl";

vec3 computeBladeGeometry() {
    // X can only have 2 values, the vertex is either on the right or on the left side.
    float xSide = float(gl_VertexID % 2);
    // The y position is the index / 2.
    float yPosition = float(gl_VertexID / 2);

    // Height percentage depends on the number of segments.
    float heightPercentage = yPosition / float(grassSegments);
    float width = grassWidth;
    float height = grassHeight;

    float x = width * xSide;
    float y = height * heightPercentage;
    float z = 0.0;

    return vec3(x, y, z);
}

vec3 getBladeOffset() {
    vec2 hashedInstanceID = quickHash(float(gl_InstanceID)) * 2.0 - 1.0;
    return vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y) * (grassPatchSize / 2.0);
}

void main() {
    vec3 grassOffset = getBladeOffset();
    vec3 bladeGeometry = computeBladeGeometry();

    vec3 grassLocalPosition = bladeGeometry + grassOffset;

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(grassLocalPosition, 1.0);
}
