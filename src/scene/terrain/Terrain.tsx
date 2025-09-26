import React from "react";
import Ground from "../ground/Ground";

const PATCH_SIZE = 5;

export type TerrainProps = {
  position: [x: number, y: number, z: number];
  size: [x: number, y: number];
  grassMaskTexture?: GroundProps["grassMaskTexture"];
};

const Terrain = ({ size, position, grassMaskTexture }: TerrainProps) => {
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
        <Ground
          key={i}
          position={pos}
          size={PATCH_SIZE}
          grassMaskTexture={grassMaskTexture}
        />
      ))}
    </group>
  );
};

export default Terrain;
