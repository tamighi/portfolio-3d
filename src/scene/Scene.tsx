import { OrbitControls } from "@react-three/drei";
import Plain from "./Plain";
import Sky from "./Sky";
import Mountain from "./Mountain";
import Sun from "./Sun";

// const useCameraSetup = () => {
//   const { camera } = useThree();
//
//   useEffect(() => {
//     camera.position.set(0, 0, 0);
//     camera.updateProjectionMatrix();
//   }, [camera]);
// };

const Scene = () => {
  // useCameraSetup();

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
