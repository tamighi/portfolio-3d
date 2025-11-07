import {
  useControls,
  type ControlInputRecords,
  type ControlValues,
} from "@tamighi/reco-panel";
import { createContext, useContext } from "react";

const WindControlsContext = createContext<ControlValues<
  typeof windControls
> | null>(null);

export const WindControlsProvider = ({
  children,
}: {
  children?: React.ReactNode;
}) => {
  const controls = useControls(windControls, { folder: "wind" });

  return <WindControlsContext value={controls}>{children}</WindControlsContext>;
};

export const useWindControls = () => {
  const controls = useContext(WindControlsContext);
  if (!controls) throw new Error("No wind control provider");
  return controls;
};
