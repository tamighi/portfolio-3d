import { OrbitControls } from "@react-three/drei";
import { useThree } from "@react-three/fiber";
import { useEffect } from "react";
import Ground from "./ground/Ground";
import Sky from "./sky/Sky";

const useCameraSetup = () => {
  const { camera } = useThree();

  useEffect(() => {
    camera.position.set(0.5, 1, 2);
    camera.lookAt(0, 0, 0);
    camera.updateProjectionMatrix();
  }, [camera]);
};

const Scene = () => {
  useCameraSetup();

  return (
    <scene>
      <OrbitControls makeDefault />
      <Sky />
      <Ground />
    </scene>
  );
};

export default Scene;
