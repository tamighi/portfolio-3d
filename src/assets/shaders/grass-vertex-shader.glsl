#include "./utils/common.glsl";

uniform int grassPatchSize;

uniform int grassVertices;
uniform int grassSegments;

uniform float grassHeight;
uniform float grassWidth;

vec3 computeGrassGeometry() {
    int xSide = gl_VertexID % 2;
    float heightPercentage = float((gl_VertexID % grassVertices) / 2) / float(grassSegments);

    float width = grassWidth * easeOut(1.0 - heightPercentage, 2.0);

    float x = width * (float(xSide) - 0.5);
    float y = heightPercentage * grassHeight;
    float z = 0.0;

    return vec3(x, y, z);
}

vec3 getGrassHash() {
    vec2 hashedInstanceID = hash21(float(gl_InstanceID));
    vec3 grassOffset = vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y);
    vec3 grassBladeWorldPos = (modelMatrix * vec4(grassOffset, 1.0)).xyz;
    return hash(grassBladeWorldPos);
}

vec3 getGrassOffset(vec3 hashVal) {
    return vec3(hashVal.x, 0.0, hashVal.y) * float(grassPatchSize) / 2.0;
}

void main() {
    vec3 hash = getGrassHash();

    vec3 grassGeometry = computeGrassGeometry();
    vec3 offset = getGrassOffset(hash);

    vec3 finalPosition = grassGeometry + offset;

    gl_Position = projectionMatrix * viewMatrix * vec4(finalPosition, 1.0);
}
