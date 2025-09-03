import { Canvas } from "@react-three/fiber";
import "./index.css";
import Scene from "./scene/Scene";
import InProgress from "./components/InProgress";

const App = () => {
  return (
    <div className="w-screen h-screen">
      <InProgress />
      <Canvas>
        <Scene />
      </Canvas>
    </div>
  );
};

export default App;
