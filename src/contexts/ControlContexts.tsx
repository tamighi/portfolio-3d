import { ControlsProvider as NativeControlsProvider } from "@tamighi/reco-panel";
import { GrassControlsProvider } from "./GrassControlContext";
import { WindControlsProvider } from "./WindControlContext";

export const ControlsProvider = ({
  children,
}: {
  children?: React.ReactNode;
}) => {
  return (
    <NativeControlsProvider>
      <GrassControlsProvider>
        <WindControlsProvider>{children}</WindControlsProvider>
      </GrassControlsProvider>
    </NativeControlsProvider>
  );
};
