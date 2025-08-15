import * as THREE from "three";
import Grass from "../grass/Grass";

type Props = {
  position?: THREE.Vector3 | [x: number, y: number, z: number];
  size?: number;
  grassMaskTexture?: THREE.Texture;
};

const Ground = (props: Props = {}) => {
  const { size = 5, position, grassMaskTexture } = props;

  return (
    <group position={position}>
      <mesh rotation-x={-Math.PI / 2}>
        <planeGeometry args={[size, size]} />
        <meshBasicMaterial color="white" />
      </mesh>
      <Grass maskTexture={grassMaskTexture} patchSize={size} />
    </group>
  );
};

export default Ground;
