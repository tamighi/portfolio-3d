#include "./utils.glsl";

uniform float grassHeight;
uniform float grassWidth;
uniform int grassVertices;
uniform int grassSegments;

void main() {
    int vertFB_ID = gl_VertexID % (grassVertices * 2);
    int vertID = vertFB_ID % grassVertices;

    // 0: left, 1: right
    int xTest = vertID & 0x1;
    // front or back
    // If vertexId > grassVertices -> other side of blade of grass.
    int zTest = (vertFB_ID >= grassVertices) ? 1 : -1;

    float xSide = float(xTest);
    float zSide = float(zTest);

    float heightPercentage = float(vertID - xTest) / float(grassSegments * 2);

    float width = grassWidth;
    float height = grassHeight;

    float x = (xSide - 0.5) * width;
    float y = heightPercentage * height;
    float z = 0.0;

    float offset = float(gl_InstanceID) * 0.5;
    vec3 grassLocalPosition = vec3(x + offset, y, z);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(grassLocalPosition, 1.0);
}

