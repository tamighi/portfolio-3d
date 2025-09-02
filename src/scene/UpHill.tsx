import tileData from "@/assets/textures/tileData.jpg";
import { useTexture } from "@react-three/drei";
import React from "react";
import Terrain, { type TerrainProps } from "./terrain/Terrain";

const UpHill = () => {
  const tileDataTexture = useTexture(tileData);

  const position = React.useMemo<TerrainProps["position"]>(() => [0, 0, 0], []);
  const size = React.useMemo<TerrainProps["size"]>(() => [3, 3], []);

  return (
    <Terrain
      grassMaskTexture={tileDataTexture}
      position={position}
      size={size}
    />
  );
};

export default UpHill;
