import usePerfLogger from "@/hooks/usePerfLogger";
import { OrbitControls } from "@react-three/drei";
import { Ground } from "./Ground";
import { useThree } from "@react-three/fiber";
import React from "react";

const useCamera = () => {
  const camera = useThree((state) => state.camera);

  React.useEffect(() => {
    camera.position.set(0, 2, 5);
  }, [camera]);
};

const Scene = () => {
  usePerfLogger();
  useCamera();

  return (
    <scene>
      <OrbitControls makeDefault />
      <Ground />
    </scene>
  );
};

export default Scene;
