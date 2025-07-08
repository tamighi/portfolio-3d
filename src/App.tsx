import { Canvas } from "@react-three/fiber";
import "./index.css";
import Scene from "./scene/Scene";

const App = () => {
  return (
    <div className="w-screen h-screen">
      <Canvas>
        <Scene />
      </Canvas>
    </div>
  );
};

export default App;
