import { OrbitControls } from "@react-three/drei";
import Plain from "./Plain";
import Sky from "./Sky";
import Mountain from "./Mountain";
import Sun from "./Sun";
import usePerfLogger from "@/hooks/usePerfLogger";

const Scene = () => {
  usePerfLogger();

  return (
    <scene>
      <OrbitControls makeDefault />
      <Sun />
      <Mountain />
      <Plain />
      <Sky />
    </scene>
  );
};

export default Scene;
