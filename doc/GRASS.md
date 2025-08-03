# Grass

[SimonDev grass tutorial](https://www.youtube.com/watch?v=bp7REZBV4P4)  
[Procedural Grass in 'Ghost of Tsushima'](https://www.youtube.com/watch?v=bp7REZBV4P4)

## Implementation

Each blade will have multiple segments (= resolution).   
Each segment will have 2 faces with 2 triangles (of 3 vertices). 

For this, we will not use a position as defined the position depending on the indices.   
The logic of the geometry indices and the vertex shader are thus dependents.    

It is better in term of memory and performance. It can however maybe lead to less flexibility (we will see).

The geometry:

```ts
const createGrassGeometry = () => {
  const indices = [];
  for (let i = 0; i < GRASS_SEGMENTS; ++i) {
    const indexOffset = i * 2;

    // first triangle
    indices.push(indexOffset + 0);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 2);

    // second triangle
    indices.push(indexOffset + 2);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 3);

    // Back face
    indices.push(indexOffset + 2);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 0);

    indices.push(indexOffset + 3);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 2);
  }

  const geo = new THREE.InstancedBufferGeometry();

  geo.instanceCount = NUM_GRASS;
  geo.setIndex(indices);

  return geo;
};
```

The vertex shader:

Base geometry:

```glsl
vec3 computeGrassGeometry(out float heightPercentage) {
    int xSide = gl_VertexID % 2;
    heightPercentage = float(gl_VertexID / 2) / float(grassSegments);

    float width = grassWidth;
    float height = grassHeight;

    float x = width * (float(xSide) - 0.5);
    float y = height * heightPercentage;
    float z = 0.0;

    return vec3(x, y, z);
}

void main() {
    float heightPercentage;
    vec3 grassGeometry = computeGrassGeometry(heightPercentage);

    vec3 grassLocalPosition = grassGeometry;
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(grassLocalPosition, 1.0);
}
```

Generate a random hash based on local (instanceId) and global (model matrix) attributes

```glsl
vec3 getGrassHash() {
    vec3 globalGrassId = (modelMatrix * vec4(float(gl_InstanceID))).xyz;
    return hash(globalGrassId);
}
```

We can generate an offset based on the hash.

```glsl
vec3 getGrassOffset(vec3 hashValue) {
    hashValue = (modelMatrix * vec4(hashValue, 1.0)).xyz * 2.0 - 1.0;
    return vec3(hashValue.y, 0.0, hashValue.z) * (grassPatchSize / 2.0);
}

//...
    vec3 grassLocalPosition = grassGeometry + grassOffset;
```

Tip the grass; depending on the height of the vertex, adapt the width.

```glsl
    float width = grassWidth * (easeOut(1.0 - heightPercentage, 2.0));
```

Add random rotations based on hash

```glsl
mat3 generateGrassMatrix(float hashValue) {
    float angle = remap(hashValue, -1.0, 1.0, -PI, PI);

    mat3 rotationMatrix = rotateY(angle);
    return rotationMatrix;
}

//...
    mat3 grassMatrix = generateGrassMatrix(hashVal.x);
    vec3 grassLocalPosition = grassMatrix * grassGeometry + grassOffset;

```

Curve the grass blade

```glsl
vec3 getGrassCurve(float hashValue, float heightPercentage) {
    float leanFactor = remap(hashValue, -1.0, 1.0, 0.0, 0.5);
    return getBezierGrassCurve(leanFactor, heightPercentage);
}

vec3 computeGrassGeometry(float hashVal, out float heightPercentage) {
    // ...
    vec3 curve = getGrassCurve(hashVal, heightPercentage);
    return vec3(x, curve.y, curve.z);
}
```

Basic coloring based on heightPercentage

```glsl
const vec3 BASE_COLOUR = vec3(0.1, 0.4, 0.04);
const vec3 TIP_COLOUR = vec3(0.5, 0.7, 0.3);

//...
    vBaseColor = mix(BASE_COLOUR, TIP_COLOUR, heightPercentage);
```

In the fragment shader:

```glsl
varying float vBaseColor;

void main() {
    vec3 baseColor = vBaseColor;
    vec3 color = baseColor;

    gl_FragColor = vec4(pow(color, vec3(1.0 / 2.2)), 1.0);
}
```

Sense of depth (add darkness on the side)

```glsl
    vGrassX = grassLocalPosition.x;
```

```glsl
    vec3 color = mix(baseColor * 0.75, baseColor, smoothstep(0.125, 0.0, abs(vGrassX)));
```
