import {
  useControls,
  type ControlInputRecords,
  type ControlValues,
} from "@tamighi/reco-panel";
import { createContext, useContext } from "react";

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
