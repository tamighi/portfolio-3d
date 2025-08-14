import fragment from "@/assets/shaders/grass-fragment-shader.glsl";
import vertex from "@/assets/shaders/grass-vertex-shader.glsl";
import { useFrame } from "@react-three/fiber";
import { useMemo } from "react";
import * as THREE from "three";

const GRASS_SEGMENTS = 6;
const GRASS_VERTICES = (GRASS_SEGMENTS + 1) * 2;
const GRASS_WIDTH = 0.125;
const GRASS_HEIGHT = 1;

const createGrassGeometry = (numberOfBlades: number) => {
  const indices = [];
  for (let i = 0; i < GRASS_SEGMENTS; ++i) {
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
  }

  const geo = new THREE.InstancedBufferGeometry();

  geo.instanceCount = numberOfBlades;
  geo.setIndex(indices);

  return geo;
};

type Props = {
  grassPatchSize?: number;
  density?: number;
  maskTexture?: THREE.Texture;
};

const Grass = (props: Props) => {
  const { grassPatchSize = 5, density = 30, maskTexture } = props;

  const area = Math.pow(grassPatchSize, 2);
  const numberOfBlades = area * density;

  const geometry = useMemo(() => createGrassGeometry(numberOfBlades), []);

  const uniforms = useMemo(
    () => ({
      grassHeight: { value: GRASS_HEIGHT },
      grassWidth: { value: GRASS_WIDTH },
      grassVertices: { value: GRASS_VERTICES },
      grassSegments: { value: GRASS_SEGMENTS },
      grassPatchSize: { value: grassPatchSize },
      tileDataTexture: { value: maskTexture },
      time: { value: 0 },
    }),
    [],
  );

  useFrame((_, delta) => {
    // update time uniform
    uniforms.time.value += delta;
  });

  return (
    <mesh geometry={geometry}>
      <shaderMaterial
        uniforms={uniforms}
        vertexShader={vertex}
        fragmentShader={fragment}
      />
    </mesh>
  );
};

export default Grass;
