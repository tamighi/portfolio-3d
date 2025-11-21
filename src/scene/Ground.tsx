import { useControlValues } from "@tamighi/reco-panel";
import Grass from "./Grass";

export const Ground = () => {
  const { density, patchSize } = useControlValues("ground");

  return (
    <group>
      <Grass density={density} patchSize={patchSize} />
      <mesh
        rotation={[-Math.PI / 2, 0, 0]}
        position={[0, 0, 0]}
        receiveShadow
        castShadow
      >
        <planeGeometry args={[patchSize, patchSize, 1, 1]} />
        <meshBasicMaterial color="#2b8cff" side={2} />
      </mesh>
    </group>
  );
};
