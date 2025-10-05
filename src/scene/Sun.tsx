const Sun = () => {
  return (
    <>
      <directionalLight
        position={[5, 10, 5]}
        intensity={1.5}
        castShadow
        shadow-mapSize-width={2048}
        shadow-mapSize-height={2048}
      />

      <ambientLight intensity={0.3} />
    </>
  );
};

export default Sun;
