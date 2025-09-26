import { useFrame } from "@react-three/fiber";
import { useControls } from "@tamighi/reco-panel";
import React from "react";

export const useWindStrength = (callback: (wind: number) => void) => {
  const [windStrength, setWindStrength] = React.useState(0);

  const { enableWind } = useControls({
    enableWind: true,
  });

  useFrame(({ clock }) => {
    const windStrength = enableWind
      ? 0.5 + Math.sin(clock.elapsedTime * 0.5) / 2
      : 0;
    callback(windStrength);
    setWindStrength(windStrength);
  });

  return windStrength;
};
