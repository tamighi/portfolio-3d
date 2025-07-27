float inverseLerp(float v, float inMin, float inMax) {
    return (v - inMin) / (inMax - inMin);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    return outMin + (v - inMin) * (outMax - outMin) / (inMax - inMin);
}

float saturate(float value) {
    return clamp(value, 0.0, 1.0);
}

vec2 quickHash(float x) {
    const vec2 k = vec2(127.1, 311.7);
    return fract(sin(vec2(x, x + 1.0) * k) * 43758.5453);
}
