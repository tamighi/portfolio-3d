const Ground = () => {
  return (
    <mesh rotation-x={-Math.PI / 2} position={[0, -0.5, 0]}>
      <planeGeometry args={[1, 1, 512, 512]} />
      <meshBasicMaterial color="white" />
    </mesh>
  );
};

export default Ground;
