import InProgress from "@/components/InProgress";
import Scene from "@/scene/Scene";
import { Canvas } from "@react-three/fiber";
import { ControlsProviders } from "@tamighi/reco-panel";
import "./index.css";

const App = () => {
  return (
    <div className="w-screen h-screen">
      <ControlsProviders>
        <InProgress />
        <Canvas>
          <Scene />
        </Canvas>
      </ControlsProviders>
    </div>
  );
};

export default App;
