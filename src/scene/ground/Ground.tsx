const Ground = () => {
  return (
    <mesh rotation-x={-Math.PI / 2}>
      <planeGeometry args={[10, 10, 512, 512]} />
      <meshBasicMaterial color="white" />
    </mesh>
  );
};

export default Ground;
