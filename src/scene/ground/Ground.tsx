import * as THREE from "three";
import Grass from "../grass/Grass";

const GROUND_SIZE = 5;

type Props = {
  position?: THREE.Vector3 | [x: number, y: number, z: number];
};

const Ground = (props: Props = {}) => {
  return (
    <group position={props.position}>
      <mesh rotation-x={-Math.PI / 2}>
        <planeGeometry args={[GROUND_SIZE, GROUND_SIZE]} />
        <meshBasicMaterial color="white" />
      </mesh>
      <Grass grassPatchSize={GROUND_SIZE} />
    </group>
  );
};

export default Ground;
