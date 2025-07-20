import { OrbitControls } from "@react-three/drei";
import Sky from "./sky/Sky";

const Scene = () => {
  return (
    <scene>
      <OrbitControls makeDefault />
      <Sky />
    </scene>
  );
};

export default Scene;
