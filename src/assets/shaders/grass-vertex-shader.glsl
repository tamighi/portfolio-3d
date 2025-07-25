#include "./utils.glsl";

uniform float time;
uniform sampler2D tileDataTexture;
uniform float grassHeight;
uniform float grassWidth;
uniform float grassVertices;
uniform float grassSegments;
uniform float grassPatchSize;

varying vec3 vColour;
varying vec4 vGrassData;
varying vec3 vNormal;
varying vec3 vWorldPosition;

float saturate(float x) {
    return clamp(x, 0.0, 1.0);
}

uvec2 murmurHash21(uint src) {
    const uint M = 0x5bd1e995u;
    uvec2 h = uvec2(1190494759u, 2147483647u);
    src *= M;
    src ^= src >> 24u;
    src *= M;
    h *= M;
    h ^= src;
    h ^= h >> 13u;
    h *= M;
    h ^= h >> 15u;
    return h;
}

// 2 outputs, 1 input
vec2 hash21(float src) {
    uvec2 h = murmurHash21(floatBitsToUint(src));
    return uintBitsToFloat(h & 0x007fffffu | 0x3f800000u) - 1.0;
}

vec2 quickHash(float p) {
    vec2 r = vec2(
            dot(vec2(p), vec2(17.43267, 23.8934543)),
            dot(vec2(p), vec2(13.98342, 37.2435232)));
    return fract(sin(r) * 1743.54892229);
}

mat3 rotateY(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(c, 0, s),
        vec3(0, 1, 0),
        vec3(-s, 0, c)
    );
}

mat3 rotateAxis(vec3 axis, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat3(
        oc * axis.x * axis.x + c, oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s,
        oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c, oc * axis.y * axis.z - axis.x * s,
        oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c
    );
}

// The MIT License
// Copyright © 2013 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org/
//
// https://www.shadertoy.com/view/Xsl3Dl
vec3 hash(vec3 p) // replace this by something better
{
    p = vec3(
            dot(p, vec3(127.1, 311.7, 74.7)),
            dot(p, vec3(269.5, 183.3, 246.1)),
            dot(p, vec3(113.5, 271.9, 124.6)));

    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(in vec3 p)
{
    vec3 i = floor(p);
    vec3 f = fract(p);

    vec3 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(mix(dot(hash(i + vec3(0.0, 0.0, 0.0)), f - vec3(0.0, 0.0, 0.0)),
                dot(hash(i + vec3(1.0, 0.0, 0.0)), f - vec3(1.0, 0.0, 0.0)), u.x),
            mix(dot(hash(i + vec3(0.0, 1.0, 0.0)), f - vec3(0.0, 1.0, 0.0)),
                dot(hash(i + vec3(1.0, 1.0, 0.0)), f - vec3(1.0, 1.0, 0.0)), u.x), u.y),
        mix(mix(dot(hash(i + vec3(0.0, 0.0, 1.0)), f - vec3(0.0, 0.0, 1.0)),
                dot(hash(i + vec3(1.0, 0.0, 1.0)), f - vec3(1.0, 0.0, 1.0)), u.x),
            mix(dot(hash(i + vec3(0.0, 1.0, 1.0)), f - vec3(0.0, 1.0, 1.0)),
                dot(hash(i + vec3(1.0, 1.0, 1.0)), f - vec3(1.0, 1.0, 1.0)), u.x), u.y), u.z);
}

vec3 terrainHeight(vec3 worldPos) {
    return vec3(worldPos.x, noise(worldPos * 0.02) * 10.0, worldPos.z);
}

const vec3 BASE_COLOUR = vec3(0.1, 0.4, 0.04);
const vec3 TIP_COLOUR = vec3(0.5, 0.7, 0.3);

void main() {
    int GRASS_SEGMENTS = int(grassSegments);
    int GRASS_VERTICES = int(grassVertices);
    float GRASS_PATCH_SIZE = grassPatchSize;
    float GRASS_WIDTH = grassWidth;
    float GRASS_HEIGHT = grassHeight;

    // Figure out grass offset
    vec2 hashedInstanceID = hash21(float(gl_InstanceID)) * 2.0 - 1.0;
    vec3 grassOffset = vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y) * GRASS_PATCH_SIZE;

    grassOffset = terrainHeight(grassOffset);

    vec3 grassBladeWorldPos = (modelMatrix * vec4(grassOffset, 1.0)).xyz;
    vec3 hashVal = hash(grassBladeWorldPos);

    float grassType = saturate(hashVal.z) > 0.75 ? 1.0 : 0.0;

    // Grass rotation
    const float PI = 3.14159;
    float angle = remap(hashVal.x, -1.0, 1.0, -PI, PI);

    vec4 tileData = texture2D(
            tileDataTexture,
            vec2(-grassBladeWorldPos.x, grassBladeWorldPos.z) / GRASS_PATCH_SIZE * 0.5 + 0.5);

    // Stiffness
    float stiffness = 1.0; // - tileData.x * 0.85;
    float tileGrassHeight = (1.0 - tileData.x) * mix(1.0, 1.5, grassType);

    // Debug
    // grassOffset = vec3(float(gl_InstanceID) * 0.5 - 8.0, 0.0, 0.0);
    // angle = float(gl_InstanceID) * 0.2;

    // Figure out vertex id, > GRASS_VERTICES is other side
    int vertFB_ID = gl_VertexID % (GRASS_VERTICES * 2);
    int vertID = vertFB_ID % GRASS_VERTICES;

    // 0 = left, 1 = right
    int xTest = vertID & 0x1;
    int zTest = (vertFB_ID >= GRASS_VERTICES) ? 1 : -1;
    float xSide = float(xTest);
    float zSide = float(zTest);
    float heightPercent = float(vertID - xTest) / (float(GRASS_SEGMENTS) * 2.0);

    float width = GRASS_WIDTH * easeOut(1.0 - heightPercent, 4.0) * tileGrassHeight;
    // float width = GRASS_WIDTH * smoothstep(0.0, 0.25, 1.0 - heightPercent);
    float height = GRASS_HEIGHT * tileGrassHeight;

    // Calculate the vertex position
    float x = (xSide - 0.5) * width;
    float y = heightPercent * height;
    float z = 0.0;

    // Grass lean factor
    float windStrength = noise(vec3(grassBladeWorldPos.xz * 0.05, 0.0) + time);
    float windAngle = 0.0;
    vec3 windAxis = vec3(cos(windAngle), 0.0, sin(windAngle));
    float windLeanAngle = windStrength * 1.5 * heightPercent * stiffness;

    // float randomLeanAnimation = sin(time * 2.0 + hashVal.y) * 0.025;
    float randomLeanAnimation = noise(
            vec3(grassBladeWorldPos.xz, time * 4.0)) * (windStrength * 0.5 + 0.125);
    // randomLeanAnimation = 0.0;
    // windStrength = 0.0;
    // windLeanAngle = 0.0;
    float leanFactor = remap(hashVal.y, -1.0, 1.0, -0.5, 0.5) + randomLeanAnimation;

    // Debug
    // leanFactor = 1.0;

    // Add the bezier curve for bend
    vec3 p1 = vec3(0.0);
    vec3 p2 = vec3(0.0, 0.33, 0.0);
    vec3 p3 = vec3(0.0, 0.66, 0.0);
    vec3 p4 = vec3(0.0, cos(leanFactor), sin(leanFactor));
    vec3 curve = bezier(p1, p2, p3, p4, heightPercent);

    // Calculate normal
    vec3 curveGrad = bezierGrad(p1, p2, p3, p4, heightPercent);
    mat2 curveRot90 = mat2(0.0, 1.0, -1.0, 0.0) * -zSide;

    y = curve.y * height;
    z = curve.z * height;

    // Generate grass matrix
    mat3 grassMat = rotateAxis(windAxis, windLeanAngle) * rotateY(angle);

    vec3 grassLocalPosition = grassMat * vec3(x, y, z) + grassOffset;
    vec3 grassLocalNormal = grassMat * vec3(0.0, curveRot90 * curveGrad.yz);

    // Blend normal
    float distanceBlend = smoothstep(
            0.0, 10.0, distance(cameraPosition, grassBladeWorldPos));
    grassLocalNormal = mix(grassLocalNormal, vec3(0.0, 1.0, 0.0), distanceBlend * 0.5);
    grassLocalNormal = normalize(grassLocalNormal);

    // Viewspace thicken
    vec4 mvPosition = modelViewMatrix * vec4(grassLocalPosition, 1.0);

    vec3 viewDir = normalize(cameraPosition - grassBladeWorldPos);
    vec3 grassFaceNormal = (grassMat * vec3(0.0, 0.0, -zSide));

    float viewDotNormal = saturate(dot(grassFaceNormal, viewDir));
    float viewSpaceThickenFactor = easeOut(
            1.0 - viewDotNormal, 4.0) * smoothstep(0.0, 0.2, viewDotNormal);

    mvPosition.x += viewSpaceThickenFactor * (xSide - 0.5) * width * 0.5 * -zSide;

    gl_Position = projectionMatrix * mvPosition;
    gl_Position.w = tileGrassHeight < 0.25 ? 0.0 : gl_Position.w;

    // vColour = grassLocalNormal;
    vColour = mix(BASE_COLOUR, TIP_COLOUR, heightPercent);
    vColour = mix(vec3(1.0, 0.0, 0.0), vColour, stiffness);
    // vColour = vec3(viewSpaceThickenFactor);
    // vec3 c1 = mix(BASE_COLOUR, TIP_COLOUR, heightPercent);
    // vec3 c2 = mix(vec3(0.6, 0.6, 0.4), vec3(0.88, 0.87, 0.52), heightPercent);
    // float noiseValue = noise(grassBladeWorldPos * 0.1);
    // vColour = mix(c1, c2, smoothstep(-1.0, 1.0, noiseValue));

    vNormal = normalize((modelMatrix * vec4(grassLocalNormal, 0.0)).xyz);
    vWorldPosition = (modelMatrix * vec4(grassLocalPosition, 1.0)).xyz;

    vGrassData = vec4(x, heightPercent, xSide, grassType);
}
