import {
  useControls,
  type ControlInputRecords,
  type ControlValues,
} from "@tamighi/reco-panel";
import { createContext, useContext } from "react";

const grassControls = {
  grassWidth: { value: 0.1, min: 0.06, max: 0.25, label: "Grass width" },
  grassHeight: { value: 1.0, min: 0.75, max: 1.6, label: "Grass height" },
  grassSegments: { value: 5, min: 1, max: 10, step: 1, label: "Resolution" },
} satisfies ControlInputRecords;

const GrassControlsContext = createContext<ControlValues<
  typeof grassControls
> | null>(null);

export const GrassControlsProvider = ({
  children,
}: {
  children?: React.ReactNode;
}) => {
  const controls = useControls(grassControls, { folder: "grass" });

  return (
    <GrassControlsContext value={controls}>{children}</GrassControlsContext>
  );
};

export const useGrassControls = () => {
  const controls = useContext(GrassControlsContext);
  if (!controls) throw new Error("No grass control provider");
  return controls;
};
