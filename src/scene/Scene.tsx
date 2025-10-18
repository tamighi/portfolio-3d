import usePerfLogger from "@/hooks/usePerfLogger";
import { OrbitControls } from "@react-three/drei";
import Plain from "./Plain";

const Scene = () => {
  usePerfLogger();

  return (
    <scene>
      <OrbitControls makeDefault />
      <Plain />
    </scene>
  );
};

export default Scene;
