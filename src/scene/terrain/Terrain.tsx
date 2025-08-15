import * as THREE from "three";
import Ground from "../ground/Ground";
import React from "react";

const PATCH_SIZE = 5;

type Props = {
  position?: THREE.Vector3 | [x: number, y: number, z: number];
  size?: THREE.Vector2 | [x: number, y: number];
  grassMaskTexture?: THREE.Texture;
};

const Terrain = ({
  size = [3, 3],
  position = [0, 0, 0],
  grassMaskTexture,
}: Props = {}) => {
  const positionArray = React.useMemo(() => {
    const [countX, countZ] = size;
    const positions: [number, number, number][] = [];

    const startX = -((countX - 1) / 2) * PATCH_SIZE;
    const startZ = -((countZ - 1) / 2) * PATCH_SIZE;

    for (let ix = 0; ix < countX; ix++) {
      for (let iz = 0; iz < countZ; iz++) {
        positions.push([startX + ix * PATCH_SIZE, 0, startZ + iz * PATCH_SIZE]);
      }
    }
    return positions;
  }, []);

  return (
    <group position={position}>
      {positionArray.map((pos, i) => (
        <Ground key={i} position={pos} grassMaskTexture={grassMaskTexture} />
      ))}
    </group>
  );
};

export default Terrain;
