import { tileDataTexture } from "@/assets/textures";
import { useTexture } from "@react-three/drei";
import React from "react";
import Ground, { type GroundProps } from "./Ground";

const Plain = () => {
  const grassMaskTexture = useTexture(tileDataTexture);

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
        grassMaskTexture={grassMaskTexture}
        position={position1}
        size={14}
      />
      <Ground
        grassMaskTexture={grassMaskTexture}
        position={position2}
        size={14}
      />
    </>
  );
};

export default Plain;
