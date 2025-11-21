#include "./utils/common.glsl";

uniform int grassPatchSize;
// TODO: Check where it's best to compute
uniform float windStrength;

uniform int grassVertices;
uniform int grassSegments;

uniform float grassHeight;
uniform float grassWidth;

vec3 getGrassCurve(float hashValue, float heightPercentage) {
    float leanFactor = remap(hashValue, -1.0, 1.0, 0.0, 0.5);

    vec3 p0 = vec3(0.0);
    vec3 p1 = vec3(0.0, grassHeight / 3.0, 0.0);
    vec3 p2 = vec3(0.0, grassHeight / 3.0, 0.0);
    vec3 p3 = vec3(0.0, cos(leanFactor) * grassHeight, sin(leanFactor));

    return bezier(heightPercentage, p0, p1, p2, p3);
}

vec3 computeGrassGeometry(float hash) {
    int xSide = gl_VertexID % 2;
    float heightPercentage = float((gl_VertexID % grassVertices) / 2) / float(grassSegments);
    float width = grassWidth * easeOut(1.0 - heightPercentage, 2.0);
    
    vec3 curve = getGrassCurve(hash, heightPercentage);

    float x = width * (float(xSide) - 0.5);
    float y = curve.y;
    float z = curve.z;

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

    vec3 grassGeometry = computeGrassGeometry(rehash(hash.x, 1.0));
    vec3 offset = getGrassOffset(hash);

    vec3 finalPosition = grassGeometry + offset;

    gl_Position = projectionMatrix * viewMatrix * vec4(finalPosition, 1.0);
}
