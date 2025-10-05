import Grass, { type GrassProps } from "./Grass";

export type GroundProps = {
  position: [x: number, y: number, z: number];
  size?: number;
  grassMaskTexture?: GrassProps["maskTexture"];
};

const Ground = (props: GroundProps) => {
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
