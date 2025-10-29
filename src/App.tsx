import InProgress from "@/components/InProgress";
import Scene from "@/scene/Scene";
import { Canvas } from "@react-three/fiber";
import { ControlsProvider } from "./contexts/ControlContexts";
import "./index.css";

const App = () => {
  return (
    <div className="w-screen h-screen">
      <ControlsProvider>
        <InProgress />
        <Canvas>
          <Scene />
        </Canvas>
      </ControlsProvider>
    </div>
  );
};

export default App;
