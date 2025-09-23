import { OrbitControls } from "@react-three/drei";
import { useThree } from "@react-three/fiber";
import { useEffect } from "react";
import Sky from "./sky/Sky";
import UpHill from "./UpHill";
import useSettings from "../hooks/useSettings";

const useCameraSetup = () => {
  const { camera } = useThree();

  useEffect(() => {
    camera.position.set(0, 3 * 2, 5 * 2);
    camera.lookAt(0, 0, 0);
    camera.updateProjectionMatrix();
  }, [camera]);
};

const GRASS_WIDTH = 0.125;
const GRASS_HEIGHT = 1;

const Scene = () => {
  useCameraSetup();

  const { grassHeight, grassWidth } = useSettings({
    grassWidth: { value: GRASS_WIDTH, label: "Grass width" },
    grassHeight: GRASS_HEIGHT,
  });

  return (
    <scene>
      <OrbitControls makeDefault />
      <Sky />
    </scene>
  );
};

export default Scene;
