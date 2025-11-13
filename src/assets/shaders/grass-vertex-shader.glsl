#include "./utils/common.glsl";

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

// TODO: Hash based on gl_instanceID and modelMatrix
vec3 getGrassHash() {
    vec2 hashedInstanceID = hash21(float(gl_InstanceID));
    vec3 grassOffset = vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y);
    vec3 grassBladeWorldPos = (modelMatrix * vec4(grassOffset, 1.0)).xyz;
    return hash(grassBladeWorldPos);
}

// TODO: Try
void main() {
    vec3 hash = getGrassHash();

    vec3 grassGeometry = computeGrassGeometry();

  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
