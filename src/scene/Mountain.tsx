import { mountainModel } from "@/assets";
import { useLoader } from "@react-three/fiber";
import { GLTFLoader } from "three/examples/jsm/Addons.js";
const Mountain = () => {
  const model = useLoader(GLTFLoader, mountainModel);

  return (
    <primitive
      object={model.scene}
      scale={[45, 45, 45]}
      position={[-31, -22, -45]}
    />
  );
};

export default Mountain;
