#include "./utils.glsl";

varying vec3 vColor;
varying vec4 vGrassData;

void main() {
    float grassX = vGrassData.x;
    vec3 baseColor = mix(vColor * 0.75, vColor, smoothstep(0.125, 0.0, abs(grassX)));
    vec3 color = baseColor;

    gl_FragColor = vec4(pow(color, vec3(1.0 / 2.2)), 1.0);
}
