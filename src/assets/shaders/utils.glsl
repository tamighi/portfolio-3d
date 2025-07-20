float inverseLerp(float v, float minValue, float maxValue) {
    return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
}

float easeOut(float x, float t) {
    return 1.0 - pow(1.0 - x, t);
}

vec3 bezier(vec3 P0, vec3 P1, vec3 P2, vec3 P3, float t) {
    return (1.0 - t) * (1.0 - t) * (1.0 - t) * P0 +
        3.0 * (1.0 - t) * (1.0 - t) * t * P1 +
        3.0 * (1.0 - t) * t * t * P2 +
        t * t * t * P3;
}
