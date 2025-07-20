#include "./utils.glsl";

void main() {
    vec3 colour = vec3(0.0);

    gl_FragColor = vec4(pow(colour, vec3(1.0 / 2.2)), 1.0);
}
