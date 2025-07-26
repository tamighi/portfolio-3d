import { OrbitControls } from "@react-three/drei";
import Sky from "./sky/Sky";
import Ground from "./ground/Ground";

const Scene = () => {
  return (
    <scene>
      <OrbitControls makeDefault />
      <Sky />
      <Ground />
    </scene>
  );
};

export default Scene;
