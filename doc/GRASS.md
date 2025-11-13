# Grass

## Resources

[SimonDev grass tutorial](https://www.youtube.com/watch?v=bp7REZBV4P4)  
[SimonDev course](https://simondev.teachable.com/courses/1783153/lectures/54145406)
[Procedural Grass in 'Ghost of Tsushima'](https://www.youtube.com/watch?v=bp7REZBV4P4)

## Implementation

### ThreeJS geometry:

We will define the vertices position based on the indices in the shader, so we don't have to define a position for each vertex.

Resolution: Each blade consist of one or multiple segments.
Each segment will have 2 faces (back and front), 2 triangles each (12 vertices per segments).

2 triangles x 2 faces.

```ts
const getGrassVerticesNumber = (grassSegments: number) => {
  return (grassSegments + 1) * 2;
};

const createGrassGeometry = (
  numberOfBlades: number,
  patchSize: number,
  grassSegments: number,
) => {
  const indices = [];
  for (let i = 0; i < grassSegments; ++i) {
    let indexOffset = i * 2;

    // tri 1
    indices.push(indexOffset + 0);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 2);

    // tri 2
    indices.push(indexOffset + 2);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 3);

    indexOffset += getGrassVerticesNumber(grassSegments);

    // face 2
    indices.push(indexOffset + 2);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 0);

    indices.push(indexOffset + 3);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 2);
  }

  const geo = new THREE.InstancedBufferGeometry();

  geo.instanceCount = numberOfBlades;
  geo.setIndex(indices);

  const size = patchSize / 2;
  geo.boundingSphere = new THREE.Sphere(
    new THREE.Vector3(0, 0, 0),
    Math.sqrt(size * size + size * size + 1 * 1),
  );

  return geo;
};
```

### Base geometry:

TODO: Explain here

```glsl
vec3 computeGrassGeometry() {
    int xSide = gl_VertexID % 2;
    float heightPercentage = float((gl_VertexID % grassVertices) / 2) / float(grassSegments);

    float width = grassWidth * easeOut(1.0 - heightPercentage, 2.0);

    float x = width * (float(xSide) - 0.5);
    float y = heightPercentage * grassHeight;
    float z = 0.0;

    return vec3(x, y, z);
}
```

### Generate a random hash

Will allow us to have randomness for each instance. 
Based on local (instance ID) and global (model matrix) attributes.

```glsl
vec3 getGrassHash() {
    vec2 hashedInstanceID = hash21(float(gl_InstanceID));
    vec3 grassOffset = vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y);
    vec3 grassBladeWorldPos = (modelMatrix * vec4(grassOffset, 1.0)).xyz;
    return hash(grassBladeWorldPos);
}
```

