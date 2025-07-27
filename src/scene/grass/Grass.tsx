import fragment from "@/assets/shaders/grass-fragment-shader.glsl";
import vertex from "@/assets/shaders/grass-vertex-shader.glsl";
import { useMemo } from "react";
import * as THREE from "three";

const GRASS_SEGMENTS = 6;
const GRASS_VERTICES = (GRASS_SEGMENTS + 1) * 2;
const GRASS_PATCH_SIZE = 1;
const NUM_GRASS = 2;
const GRASS_WIDTH = 0.1;
const GRASS_HEIGHT = 0.5;

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

const Grass = () => {
  const geometry = useMemo(() => createGrassGeometry(), []);

  const uniforms = useMemo(
    () => ({
      grassHeight: { value: GRASS_HEIGHT },
      grassWidth: { value: GRASS_WIDTH },
      grassVertices: { value: GRASS_VERTICES },
      grassSegments: { value: GRASS_SEGMENTS },
      grassPatchSize: { value: GRASS_PATCH_SIZE },
      time: { value: 0 },
    }),
    [],
  );
  return (
    <mesh geometry={geometry}>
      <shaderMaterial
        wireframe={true}
        uniforms={uniforms}
        vertexShader={vertex}
        fragmentShader={fragment}
        side={THREE.FrontSide}
      />
    </mesh>
  );
};

export default Grass;
