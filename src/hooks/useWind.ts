import { useWindControls } from "@/contexts/WindControlContext";
import { useFrame } from "@react-three/fiber";

export const useWindStrength = (callback: (wind: number) => void) => {
  const { enableWind } = useWindControls();

  useFrame(({ clock }) => {
    if (!enableWind) return;
    const windStrength = 0.5 + Math.sin(clock.elapsedTime * 0.5) / 2;
    callback(windStrength);
  });
};
