import { OrbitControls } from "@react-three/drei";

const Scene = () => {
  return (
    <scene>
      <OrbitControls makeDefault />
      <mesh>
        <boxGeometry />
        <meshStandardMaterial />
      </mesh>
    </scene>
  );
};

export default Scene;
