import fragment from "@/assets/shaders/grass-fragment-shader.glsl";
import vertex from "@/assets/shaders/grass-vertex-shader.glsl";
import React from "react";
import * as THREE from "three";

const NUM_GRASS = 4;
const GRASS_SEGMENTS = 6;
const GRASS_VERTICES = (GRASS_SEGMENTS + 1) * 2;
const GRASS_PATCH_SIZE = 10;
const GRASS_WIDTH = 0.25;
const GRASS_HEIGHT = 2;

const createGeometry = () => {
  const VERTICES = (GRASS_SEGMENTS + 1) * 2;

  const indices = [];
  for (let i = 0; i < GRASS_SEGMENTS; i++) {
    const vi = i * 2;
    indices[i * 12 + 0] = vi + 0;
    indices[i * 12 + 1] = vi + 1;
    indices[i * 12 + 2] = vi + 2;

    indices[i * 12 + 3] = vi + 2;
    indices[i * 12 + 4] = vi + 1;
    indices[i * 12 + 5] = vi + 3;

    const fi = VERTICES + vi;

    indices[i * 12 + 6] = fi + 2;
    indices[i * 12 + 7] = fi + 1;
    indices[i * 12 + 8] = fi + 0;

    indices[i * 12 + 9] = fi + 3;
    indices[i * 12 + 10] = fi + 1;
    indices[i * 12 + 11] = fi + 2;
  }

  return indices;
};

const Grass = () => {
  const geoRef = React.useRef<THREE.InstancedBufferGeometry>(null);

  const indices = React.useMemo(() => createGeometry(), []);
  const boundingSphere = React.useMemo(
    () =>
      new THREE.Sphere(new THREE.Vector3(0, 0, 0), 1 * GRASS_PATCH_SIZE * 2),
    [],
  );

  React.useEffect(() => {
    geoRef.current?.setIndex(indices);
  }, [geoRef]);

  return (
    <mesh>
      <instancedBufferGeometry
        ref={geoRef}
        boundingSphere={boundingSphere}
        instanceCount={NUM_GRASS}
      />

      <shaderMaterial
        uniforms={{
          grassHeight: {
            value: GRASS_HEIGHT,
          },
          grassWidth: {
            value: GRASS_WIDTH,
          },
          grassVertices: {
            value: GRASS_VERTICES,
          },
          grassSegments: {
            value: GRASS_SEGMENTS,
          },
        }}
        vertexShader={vertex}
        fragmentShader={fragment}
        side={THREE.FrontSide}
      />
    </mesh>
  );
};

export default Grass;
