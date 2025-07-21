import fragment from "@/assets/shaders/ground-fragment-shader.glsl";
import vertex from "@/assets/shaders/ground-vertex-shader.glsl";
import textureUrl from "@/assets/textures/grid.png";
import { useTexture } from "@react-three/drei";
import { useEffect, useRef } from "react";
import * as THREE from "three";

const Ground = () => {
  const meshRef = useRef<THREE.Mesh>(null);
  const texture = useTexture(textureUrl);
  texture.wrapS = THREE.RepeatWrapping;
  texture.wrapT = THREE.RepeatWrapping;

  useEffect(() => {
    meshRef.current?.scale.setScalar(100);
    meshRef.current?.rotateX(-Math.PI / 4);
  }, [meshRef]);

  return (
    <mesh ref={meshRef}>
      <planeGeometry args={[1, 1, 512, 512]} />

      <shaderMaterial
        vertexShader={vertex}
        fragmentShader={fragment}
        uniforms={{
          diffuseTexture: {
            value: texture,
          },
        }}
      />
    </mesh>
  );
};

export default Ground;
