import React from "react";
import SettingsContext from "../contexts/SettingsContext";
import SettingsControlDialog from "../components/SettingsControlDialog";

const SettingsProvider = ({ children }: { children: React.ReactNode }) => {
  const [settings, setSettings] = React.useState<object>({});

  return (
    <SettingsContext value={{ settings, setSettings }}>
      <SettingsControlDialog />
      {children}
    </SettingsContext>
  );
};

export default SettingsProvider;
