import React from "react";
import SettingsContext from "../contexts/SettingsContext";

const SettingsProvider = ({ children }: { children: React.ReactNode }) => {
  const [settings, setSettings] = React.useState<object>({});

  return (
    <SettingsContext value={{ settings, setSettings }}>
      {children}
    </SettingsContext>
  );
};

export default SettingsProvider;
