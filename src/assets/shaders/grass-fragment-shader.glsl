precision mediump float;

varying vec3 vBaseColor;
varying float vGrassX;

void main() {
    vec3 baseColor = mix(vBaseColor * 0.75, vBaseColor, smoothstep(0.125, 0.0, abs(vGrassX)));
    vec3 color = baseColor;

    gl_FragColor = vec4(pow(color, vec3(1.0 / 2.2)), 1.0);
}
