uniform float grassHeight;
uniform float grassWidth;
uniform int grassVertices;
uniform int grassSegments;
uniform float grassPatchSize;
uniform float time;

varying vec3 vBaseColor;
varying float vGrassX;

#include "./utils/common.glsl";

vec3 getBezierGrassCurve(float leanFactor, float heightPercentage) {
    vec3 p0 = vec3(0.0);
    vec3 p1 = vec3(0.0, 0.33, 0.0);
    vec3 p2 = vec3(0.0, 0.66, 0.0);
    vec3 p3 = vec3(0.0, cos(leanFactor), sin(leanFactor));

    return bezier(heightPercentage, p0, p1, p2, p3);
}

vec3 getGrassCurve(float hashValue, float heightPercentage) {
    float leanFactor = remap(hashValue, -1.0, 1.0, 0.0, 0.5);
    return getBezierGrassCurve(leanFactor, heightPercentage);
}

vec3 computeGrassGeometry(float hashVal, out float heightPercentage) {
    int xSide = gl_VertexID % 2;
    heightPercentage = float(gl_VertexID / 2) / float(grassSegments);

    float width = grassWidth * (easeOut(1.0 - heightPercentage, 2.0));

    float x = width * (float(xSide) - 0.5);
    vec3 curve = getGrassCurve(hashVal, heightPercentage);

    return vec3(x, curve.y, curve.z);
}

mat3 generateGrassMatrix(float hashValue) {
    float angle = remap(hashValue, -1.0, 1.0, -PI, PI);

    mat3 rotationMatrix = rotateY(angle);
    return rotationMatrix;
}

vec3 getGrassHash() {
    float id = float(gl_InstanceID);
    return hash(vec3(id, id * 1.37, id * 3.11));
}

vec3 getGrassOffset(vec3 hashValue) {
    hashValue = (modelMatrix * vec4(hashValue, 1.0)).xyz * 2.0 - 1.0;
    return vec3(hashValue.y, 0.0, hashValue.z) * (grassPatchSize / 2.0);
}

const vec3 BASE_COLOUR = vec3(0.1, 0.4, 0.04);
const vec3 TIP_COLOUR = vec3(0.5, 0.7, 0.3);

void main() {
    vec3 hashVal = getGrassHash();

    float heightPercentage;

    vec3 grassGeometry = computeGrassGeometry(hashVal.x, heightPercentage);
    vec3 grassOffset = getGrassOffset(hashVal);
    mat3 grassMatrix = generateGrassMatrix(hashVal.x);

    vec3 grassLocalPosition = grassMatrix * grassGeometry + grassOffset;

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(grassLocalPosition, 1.0);

    vBaseColor = mix(BASE_COLOUR, TIP_COLOUR, heightPercentage);
    vGrassX = grassLocalPosition.x;
}
