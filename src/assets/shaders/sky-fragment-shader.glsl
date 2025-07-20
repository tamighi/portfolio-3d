
precision highp float;

varying vec3 vWorldPosition;
varying vec2 vUv;

void main() {
    float t = vUv.y;

    vec3 topColor = vec3(0.70, 0.80, 1.0);
    vec3 bottomColor = vec3(0.83, 0.87, 1.0);

    vec3 color = mix(bottomColor, topColor, t);

    gl_FragColor = vec4(color, 1.0);
}
