import { OrbitControls } from "@react-three/drei";
import { useThree } from "@react-three/fiber";
import { useEffect } from "react";
import Ground from "./ground/Ground";
import Sky from "./sky/Sky";
import Grass from "./grass/Grass";

const useCameraSetup = () => {
  const { camera } = useThree();

  useEffect(() => {
    camera.position.set(-5, 10, -2);
    camera.lookAt(0, 0, 0);
    camera.updateProjectionMatrix();
  }, [camera]);
};

const Scene = () => {
  useCameraSetup();

  return (
    <scene>
      <OrbitControls makeDefault />
      <Ground />
      <Grass />
      <Sky />
    </scene>
  );
};

export default Scene;
