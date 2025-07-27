uniform float grassHeight;
uniform float grassWidth;
uniform int grassVertices;
uniform int grassSegments;
uniform float grassPatchSize;
uniform float time;

#include "./utils/common.glsl";

vec3 getBezierGrassCurve(float leanFactor, float heightPercentage) {
    vec3 p0 = vec3(0.0);
    vec3 p1 = vec3(0.0, 0.33, 0.0);
    vec3 p2 = vec3(0.0, 0.66, 0.0);
    vec3 p3 = vec3(0.0, cos(leanFactor), sin(leanFactor));

    return bezier(heightPercentage, p0, p1, p2, p3);
}

vec3 computeGrassGeometry(float hashValue) {
    // X can only have 2 values, the vertex is either on the right or on the left side.
    float xSide = float(gl_VertexID % 2);
    // The y position is the index / 2.
    float yPosition = float(gl_VertexID / 2);

    // Height percentage depends on the number of segments.
    float heightPercentage = yPosition / float(grassSegments);

    float width = grassWidth * (easeOut(1.0 - heightPercentage, 2.0));
    float x = width * (xSide - 0.5);

    float height = grassHeight;
    float y = height * heightPercentage;

    float z = 0.0;

    // Add a curve
    float leanFactor = remap(hashValue, -1.0, 1.0, 0.0, 0.5);
    vec3 curve = getBezierGrassCurve(leanFactor, heightPercentage);

    y = curve.y * height;
    z = curve.z * height;

    return vec3(x, y, z);
}

mat3 generateGrassMatrix(float hashValue) {
    float angle = remap(hashValue, -1.0, 1.0, -PI, PI);

    mat3 rotationMatrix = rotateY(angle);
    return rotationMatrix;
}

void main() {
    // Local hash value to rendered geometry
    vec2 hashedInstanceID = quickHash(float(gl_InstanceID)) * 2.0 - 1.0;
    vec3 grassOffset = vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y) * (grassPatchSize / 2.0);

    // Get global hash value
    vec3 grassWorldPos = (modelMatrix * vec4(grassOffset, 1.0)).xyz;
    vec3 hashVal = hash(grassWorldPos);

    vec3 grassGeometry = computeGrassGeometry(hashVal.x);
    mat3 grassMatrix = generateGrassMatrix(hashVal.x);

    vec3 grassLocalPosition = grassMatrix * grassGeometry + grassOffset;

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(grassLocalPosition, 1.0);
}
