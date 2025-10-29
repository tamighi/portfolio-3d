import { ControlsProviders as NativeControlsProviders } from "@tamighi/reco-panel";
import { GrassControlsProvider } from "./GrassControlContext";
import { WindControlsProvider } from "./WindControlContext";

export const ControlsProvider = ({
  children,
}: {
  children?: React.ReactNode;
}) => {
  return (
    <NativeControlsProviders>
      <WindControlsProvider>
        <GrassControlsProvider>{children}</GrassControlsProvider>
      </WindControlsProvider>
    </NativeControlsProviders>
  );
};
