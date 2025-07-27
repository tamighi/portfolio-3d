uniform float grassHeight;
uniform float grassWidth;
uniform int grassVertices;
uniform int grassSegments;
uniform float grassPatchSize;
uniform float time;

#include "./utils/common.glsl";

vec3 computeGrassGeometry() {
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

    return vec3(x, y, z);
}

vec3 getGrassOffset() {
    vec2 hashedInstanceID = quickHash(float(gl_InstanceID)) * 2.0 - 1.0;
    return vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y) * (grassPatchSize / 2.0);
}

mat3 generateGrassMatrix(vec3 grassWorldPos) {
    vec3 hashVal = hash(grassWorldPos);
    float angle = remap(hashVal.x, -1.0, 1.0, -PI, PI);

    mat3 rotationMatrix = rotateY(angle);
    return rotationMatrix;
}

void main() {
    vec3 grassOffset = getGrassOffset();
    vec3 grassGeometry = computeGrassGeometry();

    vec3 grassWorldPos = (modelMatrix * vec4(grassOffset, 1.0)).xyz;

    mat3 grassMatrix = generateGrassMatrix(grassWorldPos);

    vec3 grassLocalPosition = grassMatrix * grassGeometry + grassOffset;

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(grassLocalPosition, 1.0);
}
