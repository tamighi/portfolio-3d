uniform float windStrength;
uniform float grassHeight;
uniform float grassWidth;
uniform int grassVertices;
uniform int grassSegments;
uniform float grassPatchSize;
uniform sampler2D maskTexture;
uniform vec2 maskSize;

varying vec3 vBaseColor;
varying float vGrassX;
varying float vGrassY;
varying vec3 vNormal;
varying vec3 vWorldPosition;

#include "./utils/common.glsl";

vec3 computeGrassGeometry(int xSide, float heightPercentage) {
    float width = grassWidth * easeOut(1.0 - heightPercentage, 2.0);

    float x = width * (float(xSide) - 0.5);
    float y = heightPercentage * grassHeight;
    float z = 0.0;

    return vec3(x, y, z);
}

mat3 computeGrassMatrix(float hashValue) {
    float angle = remap(hashValue, -1.0, 1.0, -PI, PI);
    return rotateY(angle);
}

vec3 computeGrassRandomOffset() {
    vec2 hashedInstanceID = (hash21(float(gl_InstanceID)) - 0.5) * grassPatchSize;
    return vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y);
}

const vec3 BASE_COLOUR = vec3(0.1, 0.4, 0.04);
const vec3 TIP_COLOUR = vec3(0.5, 0.7, 0.3);

vec3 getBaseColor(float heightPercentage, vec3 grassWorldPos) {
    vec3 c1 = mix(BASE_COLOUR, TIP_COLOUR, heightPercentage);
    vec3 c2 = mix(vec3(0.6, 0.6, 0.4), vec3(0.88, 0.87, 0.52), heightPercentage);
    float noiseValue = noise(grassWorldPos * 0.1);
    return mix(c1, c2, smoothstep(-1.0, 1.0, noiseValue));
}

void getCurveControlPoints(float leanFactor, out vec3 p0, out vec3 p1, out vec3 p2, out vec3 p3) {
    p0 = vec3(0.0);
    p1 = vec3(0.0, grassHeight / 3.0, 0.0);
    p2 = vec3(0.0, grassHeight / 3.0, 0.0);
    p3 = vec3(0.0, cos(leanFactor) * grassHeight, sin(leanFactor));
}

vec3 computeCurve(float t, float leanFactor) {
    vec3 p0, p1, p2, p3;
    getCurveControlPoints(leanFactor, p0, p1, p2, p3);
    return bezier(t, p0, p1, p2, p3);
}

vec3 computeCurveTangent(float t, float leanFactor) {
    vec3 p0, p1, p2, p3;
    getCurveControlPoints(leanFactor, p0, p1, p2, p3);
    return bezierGradient(t, p0, p1, p2, p3);
}

vec3 computeNormal(vec3 curveGrad, mat3 grassMatrix) {
    float zSide = gl_VertexID >= grassVertices ? 1.0 : -1.0;
    mat2 curveRot90 = mat2(0.0, 1.0, -1.0, 0.0) * -zSide;
    vec3 grassLocalNormal = grassMatrix * vec3(0.0, curveRot90 * curveGrad.yz);
    return (modelMatrix * vec4(grassLocalNormal, 0.0)).xyz;
}

void main() {
    // Position values
    int xSide = gl_VertexID % 2;
    int zSide = gl_VertexID >= grassVertices ? 1 : -1;
    float heightPercentage = float((gl_VertexID % grassVertices) / 2) / float(grassSegments);

    // Base geometry
    vec3 grassGeometry = computeGrassGeometry(xSide, heightPercentage);

    // Offset
    vec3 grassOffset = computeGrassRandomOffset();

    // World position
    vec3 grassWorldPosition = (modelMatrix * vec4(grassOffset, 1.0)).xyz;

    // Randomness
    vec3 hashVal = hash(grassWorldPosition);

    // Wind TODO: understand & refactor
    float windStrength = noise(vec3(grassWorldPosition.xz * 0.05, 0.0) + windStrength);
    float windAngle = 0.0;
    vec3 windAxis = vec3(cos(windAngle), 0.0, sin(windAngle));
    float stiffness = 1.0;

    // Angle TODO: understand & refactor
    float windLeanAngle = windStrength * 1.5 * heightPercentage * stiffness;
    mat3 grassMatrix = rotateAxis(windAxis, windLeanAngle) * computeGrassMatrix(hashVal.z);

    // Curve TODO: understand & refactor
    float randomLeanAnimation = noise(vec3(grassWorldPosition.xz, windStrength * 0.5));
    float leanFactor = remap(hashVal.x, -1.0, 1.0, 0.0, 0.5) + randomLeanAnimation;
    vec3 curve = computeCurve(heightPercentage, leanFactor);
    grassGeometry.yz = curve.yz;

    // Grass mask
    // TODO: position, size
    vec4 mask = texture2D(
            maskTexture,
            vec2(-grassWorldPosition.x, grassWorldPosition.z) / maskSize.x + 0.5
        );
    grassGeometry.xyz *= 1.0 - mask.x;

    // Position
    vec3 grassLocalPosition = grassMatrix * grassGeometry + grassOffset;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(grassLocalPosition, 1.0);

    // Normals TODO: understand & refactor
    vec3 curveGrad = computeCurveTangent(heightPercentage, leanFactor);
    vec3 grassLocalNormal = computeNormal(curveGrad, grassMatrix);
    float distanceBlend = smoothstep(0.0, 10.0, distance(cameraPosition, grassWorldPosition));
    grassLocalNormal = mix(grassLocalNormal, vec3(0.0, 1.0, 0.0), distanceBlend);

    // TODO: understand & refactor
    vec4 mvPosition = modelViewMatrix * vec4(grassLocalPosition, 1.0);
    vec3 viewDir = normalize(cameraPosition - grassWorldPosition);
    vec3 grassFaceNormal = (grassMatrix * vec3(0.0, 0.0, float(-zSide)));
    float viewDotNormal = saturate(dot(grassFaceNormal, viewDir));
    float viewSpaceThickenFactor = easeOut(1.0 - viewDotNormal, 4.0) * smoothstep(0.0, 0.2, viewDotNormal);
    mvPosition.x += viewSpaceThickenFactor * grassGeometry.x * 0.5 * float(-zSide);
    gl_Position = projectionMatrix * mvPosition;

    // Varyings
    vBaseColor = getBaseColor(heightPercentage, grassWorldPosition);
    vWorldPosition = grassWorldPosition;
    vGrassX = grassGeometry.x;
    vGrassY = grassGeometry.y;
    vNormal = normalize(grassLocalNormal);
}
