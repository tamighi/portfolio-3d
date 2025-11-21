import { ControlsProvider as NativeControlsProvider } from "@tamighi/reco-panel";

const grassControls = {
  grassWidth: { value: 0.1, min: 0.06, max: 0.25, label: "Grass width" },
  grassHeight: { value: 1.0, min: 0.75, max: 1.6, label: "Grass height" },
  grassSegments: { value: 5, min: 1, max: 10, step: 1, label: "Resolution" },
};

const windControls = {
  enableWind: { value: true, label: "Enable wind", store: true },
};

const groundControls = {
  patchSize: { value: 5, label: "Size", min: 1, max: 10, step: 1 },
  density: { value: 30, label: "Density", min: 0, max: 50, step: 1 },
};

const controls = {
  grass: grassControls,
  wind: windControls,
  ground: groundControls,
};

declare module "@tamighi/reco-panel" {
  interface Register {
    controlTree: typeof controls;
  }
}

export const ControlsProvider = ({
  children,
}: {
  children?: React.ReactNode;
}) => {
  return (
    <NativeControlsProvider controls={controls}>
      {children}
    </NativeControlsProvider>
  );
};
