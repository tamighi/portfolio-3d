import Grass from "../grass/Grass";

const GROUND_SIZE = 5;

const Ground = () => {
  return (
    <>
      <mesh rotation-x={-Math.PI / 2}>
        <planeGeometry args={[GROUND_SIZE, GROUND_SIZE]} />
        <meshBasicMaterial color="white" />
      </mesh>
      <Grass grassPatchSize={GROUND_SIZE} />
    </>
  );
};

export default Ground;
