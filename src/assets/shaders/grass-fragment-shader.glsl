precision mediump float;

varying float vHeightPercentage;
varying float vGrassX;

const vec3 BASE_COLOUR = vec3(0.1, 0.4, 0.04);
const vec3 TIP_COLOUR = vec3(0.5, 0.7, 0.3);

void main() {
    vec3 baseColor = mix(BASE_COLOUR, TIP_COLOUR, vHeightPercentage);
    vec3 color = mix(baseColor * 0.75, baseColor, smoothstep(0.125, 0.0, abs(vGrassX)));

    gl_FragColor = vec4(pow(color, vec3(1.0 / 2.2)), 1.0);
}
