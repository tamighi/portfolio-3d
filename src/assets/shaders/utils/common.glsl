const float PI = 3.14159265358979323846;

float inverseLerp(float v, float inMin, float inMax) {
    return (v - inMin) / (inMax - inMin);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    return outMin + (v - inMin) * (outMax - outMin) / (inMax - inMin);
}

float saturate(float value) {
    return clamp(value, 0.0, 1.0);
}

float easeOut(float x, float t) {
    return 1.0 - pow(1.0 - x, t);
}

vec3 hash(vec3 p) {
    p = fract(p * vec3(0.1031, 0.1030, 0.0973));
    p += dot(p, p.yzx + 19.19);
    return fract((p.xxy + p.yzz) * p.zyx);
}

mat3 rotateY(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(c, 0.0, s,
        0.0, 1.0, 0.0,
        -s, 0.0, c);
}

vec3 bezier(float t, vec3 p0, vec3 p1, vec3 p2, vec3 p3) {
    float u = 1.0 - t;
    return u * u * u * p0 +
        3.0 * u * u * t * p1 +
        3.0 * u * t * t * p2 +
        t * t * t * p3;
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

vec2 hash21(float src) {
    uvec2 h = murmurHash21(floatBitsToUint(src));
    return uintBitsToFloat(h & 0x007fffffu | 0x3f800000u) - 1.0;
}
