precision mediump float;

varying vec3 vBaseColor;
varying float vGrassX;
varying vec3 vNormal;
varying vec3 vWorldPosition;

vec3 lambertLight(vec3 normal, vec3 viewDir, vec3 lightDir, vec3 lightColour) {
    // Simulate scattering
    float wrap = 0.5;
    float dotNL = saturate((dot(normal, lightDir) + wrap) / (1.0 + wrap));
    vec3 lighting = vec3(dotNL);

    float backlight = saturate((dot(viewDir, -lightDir) + wrap) / (1.0 + wrap));
    vec3 scatter = vec3(pow(backlight, 2.0));

    lighting += scatter;

    return lighting * lightColour;
}

vec3 hemiLight(vec3 normal, vec3 groundColor, vec3 skyColor) {
    return mix(groundColor, skyColor, 0.5 * normal.y + 0.5);
}

const vec3 GROUND_COLOR = vec3(0.05, 0.05, 0.25);
const vec3 SKY_COLOR = vec3(1.0, 1.0, 0.75);

void main() {
    vec3 normal = normalize(vNormal);
    vec3 viewDir = normalize(cameraPosition - vWorldPosition);

    vec3 lightDir = normalize(vec3(-1.0, 0.5, 1.0));
    vec3 lightColour = vec3(1.0);
    vec3 diffuseLighting = lambertLight(normal, viewDir, lightDir, lightColour);

    vec3 ambientLighting = hemiLight(normal, GROUND_COLOR, SKY_COLOR);
    vec3 baseColor = mix(vBaseColor * 0.75, vBaseColor, smoothstep(0.125, 0.0, abs(vGrassX)));

    vec3 lightning = ambientLighting * 0.5 + diffuseLighting * 0.5;
    vec3 color = vBaseColor * lightning;

    gl_FragColor = vec4(pow(color, vec3(1.0 / 2.2)), 1.0);
}
