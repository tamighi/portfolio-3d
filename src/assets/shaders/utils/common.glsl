float inverseLerp(float v, float inMin, float inMax) {
    return (v - inMin) / (inMax - inMin);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    return outMin + (v - inMin) * (outMax - outMin) / (inMax - inMin);
}

float saturate(float value) {
    return clamp(value, 0.0, 1.0);
}
