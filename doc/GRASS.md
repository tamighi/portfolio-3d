# Grass

## Resources

[SimonDev grass tutorial](https://www.youtube.com/watch?v=bp7REZBV4P4)  
[SimonDev course](https://simondev.teachable.com/courses/1783153/lectures/54145406)
[Procedural Grass in 'Ghost of Tsushima'](https://www.youtube.com/watch?v=bp7REZBV4P4)

## Implementation

Data:
- 60 FPS
- 0 draw calls

We will define the vertices position based on the indices in the shader, so we don't have to define a position for each vertex.

Each blade will have multiple segments (= resolution).   
Each segment will have 2 faces with 2 triangles (of 3 vertices). 

### ThreeJS geometry:

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

### Base geometry:

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

### Generate a random hash based on local (instance ID) and global (model matrix) attributes

```glsl
vec3 getGrassHash() {
    vec2 hashedInstanceID = hash21(float(gl_InstanceID));
    vec3 grassOffset = vec3(hashedInstanceID.x, 0.0, hashedInstanceID.y);
    vec3 grassBladeWorldPos = (modelMatrix * vec4(grassOffset, 1.0)).xyz;
    return hash(grassBladeWorldPos);
}
```

### Generate random offset

```glsl
vec3 getGrassOffset(vec3 hashVal) {
    return vec3(hashVal.x, 0.0, hashVal.y) * grassPatchSize / 2.0;
}

//...
    vec3 grassOffset = getGrassOffset();
    vec3 grassLocalPosition = grassGeometry + grassOffset;
```

### Tip the grass; depending on the height of the vertex, adapt the width.

```glsl
    float width = grassWidth * (easeOut(1.0 - heightPercentage, 2.0));
```

### Add random rotations based on hash

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

### Curve the grass blade

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

### Basic coloring based on heightPercentage

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

### Sense of depth (add darkness on the side)

```glsl
    vGrassX = grassGeometry.x;
```

```glsl
    vec3 baseColor = mix(vBaseColor * 0.75, vBaseColor, smoothstep(0.125, 0.0, abs(vGrassX)));
```

### Color variation based on noise

```glsl
vec3 getBaseColor(float heightPercentage, vec3 grassWorldPos) {
    vec3 c1 = mix(BASE_COLOUR, TIP_COLOUR, heightPercentage);
    vec3 c2 = mix(vec3(0.6, 0.6, 0.4), vec3(0.88, 0.87, 0.52), heightPercentage);
    float noiseValue = noise(grassWorldPos * 0.1);
    return mix(c1, c2, smoothstep(-0.4, 0.4, noiseValue));
}
```

### Lightning based on surface normals

#### Face identification

1. Vertex ID differenciation for the faces

```ts
    let indexOffset = i * 2;

    indices.push(indexOffset + 0);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 2);

    indices.push(indexOffset + 2);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 3);

    indexOffset += GRASS_VERTICES;

    indices.push(indexOffset + 2);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 0);

    indices.push(indexOffset + 3);
    indices.push(indexOffset + 1);
    indices.push(indexOffset + 2);
```

2. Take that into account in height and we can also check the side of the vertex:

```glsl
    heightPercentage = float((gl_VertexID % grassVertices) / 2) / float(grassSegments);
    //...
    int t = gl_VertexID % (grassVertices * 2);
    float side = t >= grassVertices ? 1.0 : -1.0;
```

#### Hemilight

```glsl
    int t = gl_VertexID % (grassVertices * 2);
    float zSide = t >= grassVertices ? 1.0 : -1.0;
    mat2 curveRot90 = mat2(0.0, 1.0, -1.0, 0.0) * -zSide;
    vec3 curveGrad = bezierGradient(heightPercentage, p1, p2, p3, p4);
    vec3 grassLocalNormal = grassMatrix * vec3(0.0, curveRot90 * curveGrad.yz);
    vNormal = normalize((modelMatrix * vec4(grassLocalNormal, 0.0)).xyz);
```

```glsl
    vec3 ambientLighting = hemiLight(normalize(vNormal), GROUND_COLOR, SKY_COLOR);
```
