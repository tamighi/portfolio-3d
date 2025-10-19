import usePerfLogger from "@/hooks/usePerfLogger";
import { OrbitControls } from "@react-three/drei";
import Grass from "./Grass";

const Scene = () => {
  usePerfLogger();

  return (
    <scene>
      <OrbitControls makeDefault />
      <Grass patchSize={5} />
    </scene>
  );
};

export default Scene;
