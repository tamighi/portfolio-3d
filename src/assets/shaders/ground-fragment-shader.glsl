#include "./utils.glsl"

varying vec3 vWorldPosition;
varying vec3 vWorldNormal;
varying vec2 vUv;

uniform sampler2D diffuseTexture;

float hash(vec2 p)
{
    p = 50.0 * fract(p * 0.3183099 + vec2(0.71, 0.113));
    return -1.0 + 2.0 * fract(p.x * p.y * (p.x + p.y));
}

void main() {
    float grid1 = texture(diffuseTexture, vWorldPosition.xz * 0.1).r;
    float grid2 = texture(diffuseTexture, vWorldPosition.xz * 1.0).r;

    float gridHash1 = hash(floor(vWorldPosition.xz * 1.0));

    vec3 gridColour = mix(vec3(0.5 + remap(gridHash1, -1.0, 1.0, -0.2, 0.2)), vec3(0.0625), grid2);
    gridColour = mix(gridColour, vec3(0.00625), grid1);

    vec3 colour = gridColour;

    gl_FragColor = vec4(pow(colour, vec3(1.0 / 2.2)), 1.0);
}
