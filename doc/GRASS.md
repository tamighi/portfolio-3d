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

### Random hash

Will allow us to have randomness for each instance. 
Based on local (instance ID) and global (model matrix) attributes.

Note that the hashValue has to be randomized if reused, else it can create weird results


```glsl
vec3 getGrassHash() {
    vec2 hashedInstanceID = hash21(float(gl_InstanceID));
    vec3 grassOffset = vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y);
    vec3 grassBladeWorldPos = (modelMatrix * vec4(grassOffset, 1.0)).xyz;
    return hash(grassBladeWorldPos);
}

float rand(float x, float seed) {
    return fract(sin((x + seed * 17.0) * 78.233) * 43758.5453);
}
```

### Base geometry:

Position based on the geometry indices (gl_VertexID): 
- y: 
    - Normalize the number (gl_VertexID % grassVertices)
    - Divide by 2 (2 vertices heightPercentage, one for each side)
    - Divide by number of segments to normalize height.
    - Transform percentage to height.
- x: 
    - The width + we join the vertices at the top.
    - Place and center based on the side on X axis.

```glsl
vec3 getGrassCurve(float hashValue, float heightPercentage) {
    float leanFactor = remap(hashValue, -1.0, 1.0, 0.0, 0.5);

    vec3 p0 = vec3(0.0);
    vec3 p1 = vec3(0.0, grassHeight / 3.0, 0.0);
    vec3 p2 = vec3(0.0, grassHeight / 3.0, 0.0);
    vec3 p3 = vec3(0.0, cos(leanFactor) * grassHeight, sin(leanFactor));

    return bezier(heightPercentage, p0, p1, p2, p3);
}

vec3 getGrassGeometry(float hash) {
    int xSide = gl_VertexID % 2;
    float heightPercentage = float((gl_VertexID % grassVertices) / 2) / float(grassSegments);
    float width = grassWidth * easeOut(1.0 - heightPercentage, 2.0);
    
    vec3 curve = getGrassCurve(hash, heightPercentage);

    float x = width * (float(xSide) - 0.5);
    float y = curve.y;
    float z = curve.z;

    return vec3(x, y, z);
}
```

### Offset

```glsl
vec3 getGrassOffset(vec3 hashVal) {
    return vec3(hashVal.x, 0.0, hashVal.y) * grassPatchSize / 2.0;
}
```

### Angle

```glsl
mat3 getGrassMatrix(float hashValue) {
    float angle = remap(hashValue, -1.0, 1.0, -PI, PI);

    mat3 rotationMatrix = rotateY(angle);
    return rotationMatrix;
}
```
