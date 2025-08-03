precision mediump float;

varying vec3 vBaseColor;
varying float vGrassX;

void main() {
    vec3 baseColor = vBaseColor;
    vec3 color = mix(baseColor * 0.75, baseColor, smoothstep(0.125, 0.0, abs(vGrassX)));

    gl_FragColor = vec4(pow(color, vec3(1.0 / 2.2)), 1.0);
}
