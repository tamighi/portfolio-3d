import usePerfLogger from "@/hooks/usePerfLogger";
import { OrbitControls } from "@react-three/drei";
import Grass from "./Grass";

const Scene = () => {
  usePerfLogger();
  console.log("🎬 Scene rendered");
  return (
    <scene>
      <OrbitControls makeDefault />
      <Grass patchSize={5} />
    </scene>
  );
};

export default Scene;
