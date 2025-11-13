import usePerfLogger from "@/hooks/usePerfLogger";
import { OrbitControls } from "@react-three/drei";
import Grass from "./Grass";
import { useControlValues } from "@tamighi/reco-panel";

const Scene = () => {
  usePerfLogger();

  const { patchSize, density } = useControlValues("ground");

  return (
    <scene>
      <OrbitControls makeDefault />
      <Grass patchSize={patchSize} density={density} />
    </scene>
  );
};

export default Scene;
