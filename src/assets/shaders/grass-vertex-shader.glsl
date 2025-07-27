uniform float grassHeight;
uniform float grassWidth;
uniform int grassVertices;
uniform int grassSegments;
uniform int grassPatchSize;
uniform float time;

void main() {
    float xSide = float(gl_VertexID % 2);
    float yPosition = float(gl_VertexID / 2);

    float heightPercentage = yPosition / float(grassSegments);
    float width = grassWidth;
    float height = grassHeight;

    float x = width * xSide;
    float y = height * heightPercentage;
    float z = 0.0;

    float offset = float(gl_InstanceID) / 4.0;

    vec3 grassLocalPosition = vec3(x + offset, y, z);

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(grassLocalPosition, 1.0);
}
