import tileData from "@/assets/textures/tileData.jpg";
import { useTexture } from "@react-three/drei";
import React from "react";
import Ground, { type GroundProps } from "./ground/Ground";

const Plain = () => {
  const tileDataTexture = useTexture(tileData);

  const position1 = React.useMemo<GroundProps["position"]>(
    () => [-6, -3, -4],
    [],
  );

  const position2 = React.useMemo<GroundProps["position"]>(
    () => [6, -3, -4],
    [],
  );

  return (
    <>
      <Ground
        grassMaskTexture={tileDataTexture}
        position={position1}
        size={14}
      />
      <Ground
        grassMaskTexture={tileDataTexture}
        position={position2}
        size={14}
      />
    </>
  );
};

export default Plain;
