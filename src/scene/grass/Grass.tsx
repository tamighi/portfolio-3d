import fragment from "@/assets/shaders/grass-fragment-shader.glsl";
import vertex from "@/assets/shaders/grass-vertex-shader.glsl";
import { useWindStrength } from "@/hooks/useWind";
import { useControls } from "@tamighi/reco-panel";
import React from "react";
import * as THREE from "three";

const GRASS_SEGMENTS = 3;
const GRASS_VERTICES = (GRASS_SEGMENTS + 1) * 2;
const GRASS_WIDTH = 0.125;
const GRASS_HEIGHT = 1;

const createGrassGeometry = (numberOfBlades: number, patchSize: number) => {
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

  const size = patchSize / 2;
  geo.boundingSphere = new THREE.Sphere(
    new THREE.Vector3(0, 0, 0),
    Math.sqrt(size * size + size * size + 1 * 1),
  );

  return geo;
};

export type GrassProps = {
  patchSize?: number;
  density?: number;
  maskTexture?: THREE.Texture;
};

const Grass = ({ patchSize = 5, density = 30, maskTexture }: GrassProps) => {
  const area = Math.pow(patchSize, 2);
  const numberOfBlades = area * density;

  const geometry = React.useMemo(
    () => createGrassGeometry(numberOfBlades, patchSize),
    [],
  );

  const uniforms = React.useMemo(
    () => ({
      grassHeight: { value: GRASS_HEIGHT },
      grassWidth: { value: GRASS_WIDTH },
      grassVertices: { value: GRASS_VERTICES },
      grassSegments: { value: GRASS_SEGMENTS },
      grassPatchSize: { value: patchSize },
      maskTexture: { value: maskTexture },
      maskSize: { value: new THREE.Vector2(5, 5) },
      windStrength: { value: 0 },
    }),
    [],
  );

  useWindStrength(
    (windStrength) => (uniforms.windStrength.value = windStrength),
  );

  const { grassHeight, grassWidth } = useControls({
    grassWidth: {
      value: GRASS_WIDTH,
      label: "Grass width",
      min: 0.06,
      max: 0.25,
    },
    grassHeight: {
      value: GRASS_HEIGHT,
      label: "Grass height",
      min: 0.75,
      max: 1.6,
    },
  });

  React.useEffect(() => {
    uniforms.grassHeight.value = grassHeight;
    uniforms.grassWidth.value = grassWidth;
  }, [grassWidth, grassHeight]);

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
