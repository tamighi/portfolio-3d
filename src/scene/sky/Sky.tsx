import fragment from "@/assets/shaders/sky-fragment-shader.glsl";
import vertex from "@/assets/shaders/sky-vertex-shader.glsl";
import * as THREE from "three";

const Sky = () => {
  return (
    <mesh receiveShadow={false} castShadow={false}>
      <sphereGeometry args={[50, 32, 15]} />

      <shaderMaterial
        vertexShader={vertex}
        fragmentShader={fragment}
        side={THREE.BackSide}
      />
    </mesh>
  );
};

export default Sky;
