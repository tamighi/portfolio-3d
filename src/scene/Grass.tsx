import { grassFragmentShader, grassVertexShader } from "@/assets";
import { useWindStrength } from "@/hooks/useWind";
import { useControls } from "@tamighi/reco-panel";
import React from "react";
import * as THREE from "three";

const GRASS_SEGMENTS = 6;
const GRASS_WIDTH = 0.125;
const GRASS_HEIGHT = 1;

const getGrassVerticeNumber = (grassSegments: number) => {
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

    indexOffset += getGrassVerticeNumber(grassSegments);

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

  const { grassHeight, grassWidth, grassSegments } = useControls({
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
    grassSegments: {
      value: GRASS_SEGMENTS,
      label: "Resolution",
      min: 1,
      max: 10,
      step: 1,
    },
  });

  const geometry = React.useMemo(
    () => createGrassGeometry(numberOfBlades, patchSize, grassSegments),
    [grassSegments],
  );

  const uniforms = React.useMemo(
    () => ({
      grassHeight: { value: grassHeight },
      grassWidth: { value: grassWidth },
      grassVertices: { value: getGrassVerticeNumber(grassSegments) },
      grassSegments: { value: grassSegments },
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

  React.useEffect(() => {
    uniforms.grassHeight.value = grassHeight;
    uniforms.grassWidth.value = grassWidth;
    uniforms.grassSegments.value = grassSegments;
    uniforms.grassVertices.value = getGrassVerticeNumber(grassSegments);
  }, [grassWidth, grassHeight, grassSegments]);

  return (
    <mesh geometry={geometry}>
      <shaderMaterial
        uniforms={uniforms}
        vertexShader={grassVertexShader}
        fragmentShader={grassFragmentShader}
      />
    </mesh>
  );
};

export default Grass;
