#include "./utils.glsl";

uniform float grassHeight;
uniform float grassWidth;
uniform float grassVertices;
uniform float grassSegments;
uniform float grassPatchSize;

varying vec3 vColor;
varying vec4 vGrassData;

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

vec2 quickHash(float p) {
    vec2 r = vec2(
            dot(vec2(p), vec2(17.43267, 23.8934543)),
            dot(vec2(p), vec2(13.98342, 37.2435232)));
    return fract(sin(r) * 1743.54892229);
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

mat3 rotateY(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(c, 0, s),
        vec3(0, 1, 0),
        vec3(-s, 0, c)
    );
}

const vec3 BASE_COLOR = vec3(0.1, 0.4, 0.04);
const vec3 TIP_COLOR = vec3(0.5, 0.7, 0.3);

void main() {
    // Offset based on instance id
    vec2 hashedInstanceId = hash21(float(gl_InstanceID)) * 2.0 - 1.0;
    vec3 grassOffset = vec3(hashedInstanceId.x, 0.0, hashedInstanceId.y) * grassPatchSize;

    // Rotation
    vec3 grassBladeWorldPos = (modelMatrix * vec4(grassOffset, 1.0)).xyz;
    vec3 hashVal = hash(grassBladeWorldPos);
    const float PI = 3.14159;
    float angle = remap(hashVal.x, -1.0, 1.0, -PI, PI);

    //
    int vertFB_ID = gl_VertexID % (int(grassVertices) * 2);
    int vertID = vertFB_ID % int(grassVertices);

    // Left or right
    int xTest = vertID % 2;

    // Front or Back
    int zTest = (vertFB_ID >= int(grassVertices)) ? 1 : -1;

    float xSide = float(xTest);
    float zSide = float(zTest);

    float heightPercentage = float(vertID - xTest) / (grassSegments * 2.0);

    float width = grassWidth;

    // Reduce width as we go up
    width *= easeOut(1.0 - heightPercentage, 2.0);

    float height = grassHeight;

    float x = (xSide - 0.5) * width;
    float y = heightPercentage * height;
    float z = 0.0;

    // Lean factor
    float leanFactor = remap(hashVal.y, -1.0, 1.0, 0.0, 0.75);

    // Bending
    vec3 p1 = vec3(0.0);
    vec3 p2 = vec3(0.0, 0.33, 0.0);
    vec3 p3 = vec3(0.0, 0.66, 0.0);
    vec3 p4 = vec3(0.0, cos(leanFactor), sin(leanFactor));
    vec3 curve = bezier(p1, p2, p3, p4, heightPercentage);

    y = curve.y * height;
    z = curve.z * height;

    // Grass matrix
    mat3 grassMat = rotateY(angle);

    vec3 grassLocalPosition = grassMat * vec3(x, y, z) + grassOffset;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(grassLocalPosition, 1.0);

    // vColor = mix(BASE_COLOR, TIP_COLOR, heightPercentage);
    vec3 c1 = mix(BASE_COLOR, TIP_COLOR, heightPercentage);
    vec3 c2 = mix(vec3(0.6, 0.6, 0.4), vec3(0.88, 0.87, 0.52), heightPercentage);
    float noiseValue = noise(grassBladeWorldPos * 0.1);
    vColor = mix(c1, c2, smoothstep(-1.0, 1.0, noiseValue));

    vGrassData = vec4(x, 0.0, 0.0, 0.0);
}

