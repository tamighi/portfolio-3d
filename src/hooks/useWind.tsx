import { useFrame } from "@react-three/fiber";
import { useControls } from "@tamighi/reco-panel";

export const useWindStrength = (callback: (wind: number) => void) => {
  const { enableWind } = useControls(
    {
      enableWind: true,
    },
    { store: true },
  );

  useFrame(({ clock }) => {
    const windStrength = enableWind
      ? 0.5 + Math.sin(clock.elapsedTime * 0.5) / 2
      : 0;
    callback(windStrength);
  });
};
