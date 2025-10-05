import usePerfLogger from "@/hooks/usePerfLogger";
import { OrbitControls } from "@react-three/drei";
import Mountain from "./Mountain";
import Plain from "./Plain";
import Sky from "./Sky";
import Sun from "./Sun";

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
