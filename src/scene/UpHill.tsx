import tileData from "@/assets/textures/tileData.jpg";
import { useTexture } from "@react-three/drei";
import Terrain from "./terrain/Terrain";

const UpHill = () => {
  const tileDataTexture = useTexture(tileData);

  return <Terrain grassMaskTexture={tileDataTexture} />;
};

export default UpHill;
