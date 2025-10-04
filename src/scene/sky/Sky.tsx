import { skyFragmentShader, skyVertexShader } from "@/assets";
import * as THREE from "three";

const Sky = () => {
  return (
    <mesh receiveShadow={false} castShadow={false}>
      <sphereGeometry args={[50, 32, 15]} />

      <shaderMaterial
        vertexShader={skyVertexShader}
        fragmentShader={skyFragmentShader}
        side={THREE.BackSide}
      />
    </mesh>
  );
};

export default Sky;
