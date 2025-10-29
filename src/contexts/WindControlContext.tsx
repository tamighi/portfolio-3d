import { useControls, type UseControlsReturn } from "@tamighi/reco-panel";
import { createContext, useContext } from "react";

const windControls = {
  enableWind: { value: true, label: "Enable wind" },
};

const WindControlsContext = createContext<UseControlsReturn<
  typeof windControls
> | null>(null);

export const WindControlsProvider = ({
  children,
}: {
  children?: React.ReactNode;
}) => {
  const controls = useControls(windControls, { store: true });

  return <WindControlsContext value={controls}>{children}</WindControlsContext>;
};

export const useWindControls = () => {
  const controls = useContext(WindControlsContext);
  if (!controls) throw new Error("No wind control provider");
  return controls;
};
