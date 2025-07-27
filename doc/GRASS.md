# Grass

[SimonDev grass tutorial](https://www.youtube.com/watch?v=bp7REZBV4P4)  
[Procedural Grass in 'Ghost of Tsushima'](https://www.youtube.com/watch?v=bp7REZBV4P4)

## Implementation

Each blade will have multiple segments (= resolution).   
Each segment will have 2 triangles (of 3 vertices). 

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
  }

  const geo = new THREE.InstancedBufferGeometry();

  geo.instanceCount = NUM_GRASS;
  geo.setIndex(indices);

  return geo;
};
```

The vertex shader:

```glsl
void main() {
    // X can only have 2 values, the vertex is either on the right or on the left side.
    float xSide = float(gl_VertexID % 2);
    // The y position is the index / 2.
    float yPosition = float(gl_VertexID / 2);

    // Height percentage depends on the number of segments.
    float heightPercentage = yPosition / float(grassSegments);
    float width = grassWidth;
    float height = grassHeight;

    float x = width * xSide;
    float y = height * heightPercentage;
    float z = 0.0;

    vec3 grassOffset = vec3(0.0);
    vec3 grassLocalPosition = vec3(x , y, z) + grassOffset;

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(grassLocalPosition, 1.0);
}
```

We can generate an offset based on the instance ID.

```glsl
void main() {
    // Local to rendered geometry
    vec2 hashedInstanceID = quickHash(float(gl_InstanceID)) * 2.0 - 1.0;
    vec3 grassOffset = vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y) * (grassPatchSize / 2.0);

    // Refactor of the above
    vec3 grassGeometry = computeGrassGeometry();

    vec3 grassLocalPosition = grassGeometry + grassOffset;

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(grassLocalPosition, 1.0);
}
```

Tip the grass; depending on the height of the vertex, adapt the width.

```glsl
    float width = grassWidth * (easeOut(1.0 - heightPercentage, 2.0));
    float x = width * (xSide - 0.5);
```

Add random rotations based on global grass position

```glsl
mat3 generateGrassMatrix(float hashValue) {
    float angle = remap(hashValue, -1.0, 1.0, -PI, PI);

    mat3 rotationMatrix = rotateY(angle);
    return rotationMatrix;
}
```

```glsl
    // Get global hash value
    vec3 grassWorldPos = (modelMatrix * vec4(grassOffset, 1.0)).xyz;
    vec3 hashVal = hash(grassWorldPos);

    mat3 grassMatrix = generateGrassMatrix(hashVal.x);
    vec3 grassLocalPosition = grassMatrix * grassGeometry + grassOffset;
```

Curve the grass blade

```glsl
vec3 computeGrassGeometry(float hashValue) {
    // ...
    // Add a curve
    float leanFactor = remap(hashValue, -1.0, 1.0, 0.0, 0.5);
    vec3 curve = getBezierGrassCurve(leanFactor, heightPercentage);

    y = curve.y * height;
    z = curve.z * height;

    return vec3(x, y, z);
}
```

Basic coloring based on heightPercentage

```glsl
varying float vHeightPercentage;

const vec3 BASE_COLOUR = vec3(0.1, 0.4, 0.04);
const vec3 TIP_COLOUR = vec3(0.5, 0.7, 0.3);

void main() {
    vec3 baseColor = mix(BASE_COLOUR, TIP_COLOUR, vHeightPercentage);
    vec3 color = baseColor;

    gl_FragColor = vec4(pow(color, vec3(1.0 / 2.2)), 1.0);
}
```
