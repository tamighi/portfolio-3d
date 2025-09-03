import { Canvas } from "@react-three/fiber";
import InProgress from "./components/InProgress";
import "./index.css";
import Scene from "./scene/Scene";
import SettingsProvider from "./providers/SettingsProvider";

const App = () => {
  return (
    <div className="w-screen h-screen">
      <SettingsProvider>
        <InProgress />
        <Canvas>
          <Scene />
        </Canvas>
      </SettingsProvider>
    </div>
  );
};

export default App;
