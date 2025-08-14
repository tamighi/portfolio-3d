import tileData from "@/assets/textures/tileData.jpg";
import { useTexture } from "@react-three/drei";
import Ground from "./ground/Ground";

const PATCH_SIZE = 5;

const UpHill = () => {
  const xArr = [-PATCH_SIZE, 0, PATCH_SIZE];
  const yArr = [-PATCH_SIZE, 0, PATCH_SIZE];

  const tileDataTexture = useTexture(tileData);

  return (
    <group>
      {xArr.map((x) =>
        yArr.map((y) => (
          <Ground
            grassMaskTexture={tileDataTexture}
            key={`${x}-${y}`}
            size={PATCH_SIZE}
            position={[x, 0, y]}
          />
        )),
      )}
    </group>
  );
};

export default UpHill;
