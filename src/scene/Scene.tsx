import { OrbitControls } from "@react-three/drei";
import Plain from "./Plain";
import Sky from "./sky/Sky";

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
      <Plain />
      <Sky />
    </scene>
  );
};

export default Scene;
