import InProgress from "@/components/InProgress";
import Scene from "@/scene/Scene";
import { Canvas } from "@react-three/fiber";
import { ControlsProviders } from "@tamighi/reco-panel";
import "./index.css";
import { GrassControlsProvider } from "./contexts/GrassControlContext";

const App = () => {
  return (
    <div className="w-screen h-screen">
      <ControlsProviders>
        <GrassControlsProvider>
          <InProgress />
          <Canvas>
            <Scene />
          </Canvas>
        </GrassControlsProvider>
      </ControlsProviders>
    </div>
  );
};

export default App;
