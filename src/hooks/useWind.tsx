import { useFrame } from "@react-three/fiber";
import {
  useControlValuesSubscription,
  type ValueControlLeaf,
} from "@tamighi/reco-panel";
import React from "react";

export const useWindStrength = (callback: (wind: number) => void) => {
  const cb = React.useCallback((newControls: ValueControlLeaf<"wind">) => {
    windControlsRef.current = newControls;
  }, []);

  const windControls = useControlValuesSubscription("wind", cb);
  const windControlsRef = React.useRef(windControls);

  useFrame(({ clock }) => {
    if (!windControlsRef.current.enableWind) return;
    const windStrength = 0.5 + Math.sin(clock.elapsedTime * 0.5) / 2;
    callback(windStrength);
  });
};
