import { OrbitControls } from "@react-three/drei";
import { useThree } from "@react-three/fiber";
import { useEffect } from "react";
import Sky from "./sky/Sky";
import UpHill from "./UpHill";

const useCameraSetup = () => {
  const { camera } = useThree();

  useEffect(() => {
    camera.position.set(0, 3 * 2, 5 * 2);
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
      <UpHill />
    </scene>
  );
};

export default Scene;
