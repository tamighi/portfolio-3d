#include "./utils.glsl";

uniform vec2 resolution;
uniform float time;
// uniform sampler2DArray grassDiffuse;

varying vec3 vColour;
varying vec4 vGrassData;
varying vec3 vNormal;
varying vec3 vWorldPosition;

float saturateX(float x) {
    return clamp(x, 0.0, 1.0);
}

vec3 lambertLight(vec3 normal, vec3 viewDir, vec3 lightDir, vec3 lightColour) {
    float wrap = 0.5;
    float dotNL = saturateX((dot(normal, lightDir) + wrap) / (1.0 + wrap));
    vec3 lighting = vec3(dotNL);

    float backlight = saturateX((dot(viewDir, -lightDir) + wrap) / (1.0 + wrap));
    vec3 scatter = vec3(pow(backlight, 2.0));

    lighting += scatter;

    return lighting * lightColour;
}

vec3 hemiLight(vec3 normal, vec3 groundColour, vec3 skyColour) {
    return mix(groundColour, skyColour, 0.5 * normal.y + 0.5);
}

vec3 phongSpecular(vec3 normal, vec3 lightDir, vec3 viewDir) {
    float dotNL = saturateX(dot(normal, lightDir));

    vec3 r = normalize(reflect(-lightDir, normal));
    float phongValue = max(0.0, dot(viewDir, r));
    phongValue = pow(phongValue, 32.0);

    vec3 specular = dotNL * vec3(phongValue);
    return specular;
}

void main() {
    float grassX = vGrassData.x;
    float grassY = vGrassData.y;
    float grassType = vGrassData.w;

    vec3 normal = normalize(vNormal);
    vec3 viewDir = normalize(cameraPosition - vWorldPosition);

    vec3 baseColour = mix(
            vColour * 0.75, vColour, smoothstep(0.125, 0.0, abs(grassX)));

    vec2 uv = vGrassData.zy;
    // vec4 baseColour = texture2D(grassDiffuse, vec3(uv, grassType));

    // if (baseColour.w < 0.5) discard;

    // Hemi
    vec3 c1 = vec3(1.0, 1.0, 0.75);
    vec3 c2 = vec3(0.05, 0.05, 0.25);

    vec3 ambientLighting = hemiLight(normal, c2, c1);

    // Directional light
    vec3 lightDir = normalize(vec3(-1.0, 0.5, 1.0));
    vec3 lightColour = vec3(1.0);
    vec3 diffuseLighting = lambertLight(normal, viewDir, lightDir, lightColour);

    // Specular
    vec3 specular = phongSpecular(normal, lightDir, viewDir);

    // Fake AO
    float ao = remap(pow(grassY, 2.0), 0.0, 1.0, 0.125, 1.0);

    vec3 lighting = diffuseLighting * 0.5 + ambientLighting * 0.5;

    vec3 colour = baseColour.xyz * ambientLighting + specular * 0.25;
    colour *= ao;

    // colour = lighting;
    // colour = vColour;

    gl_FragColor = vec4(pow(colour, vec3(1.0 / 2.2)), 1.0);
}
