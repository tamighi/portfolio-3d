# Grass

[SimonDev grass tutorial](https://www.youtube.com/watch?v=bp7REZBV4P4)
[Procedural Grass in 'Ghost of Tsushima'](https://www.youtube.com/watch?v=bp7REZBV4P4)

## Implementation

### Single blade

Each blade will have multiple segments (= resolution).   
Each segment will have 2 triangles (of 3 vertices). 

For this, we will not use a position as defined the position depending on the indices.   
The logic of the geometry indices and the vertex shader are thus dependents.    

The geometry:

```ts
const createGrassGeometry = () => {
  const indices = [];
  for (let i = 0; i < GRASS_SEGMENTS; ++i) {
    const indexOffset = i * 2;

    indices.push(indexOffset + 0);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 2);

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

    float offset = float(gl_InstanceID) / 4.0;

    vec3 grassLocalPosition = vec3(x + offset, y, z);

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(grassLocalPosition, 1.0);
}
```
