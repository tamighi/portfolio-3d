import { mountainModel } from "@/assets";
import { useLoader } from "@react-three/fiber";
import { GLTFLoader } from "three/examples/jsm/Addons.js";

const Mountain = () => {
  const model = useLoader(GLTFLoader, mountainModel);

  return <primitive object={model.scene} />;
};

export default Mountain;
