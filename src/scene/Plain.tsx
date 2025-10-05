import { tileDataTexture } from "@/assets/textures";
import { useTexture } from "@react-three/drei";
import React from "react";
import Ground, { type GroundProps } from "./Ground";

const Plain = () => {
  const grassMaskTexture = useTexture(tileDataTexture);

  const positions = React.useMemo<GroundProps["position"][]>(
    () => Array.from({ length: 3 }).map((_, i) => [(i - 1) * 8, -3, -1]),
    [],
  );

  return (
    <>
      {positions.map((pos, i) => (
        <Ground
          key={i}
          grassMaskTexture={grassMaskTexture}
          position={pos}
          size={8}
        />
      ))}
    </>
  );
};

export default Plain;
