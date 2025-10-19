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

    indices.push(indexOffset + 0);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 2);

    indices.push(indexOffset + 2);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 3);

    indexOffset += getGrassVerticesNumber(grassSegments);

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
