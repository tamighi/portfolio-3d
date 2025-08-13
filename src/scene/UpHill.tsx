import Ground from "./ground/Ground";

const UpHill = () => {
  return (
    <group>
      <Ground position={[2.5, 0, 0]} />
      <Ground position={[-2.5, 0, 0]} />
    </group>
  );
};

export default UpHill;
