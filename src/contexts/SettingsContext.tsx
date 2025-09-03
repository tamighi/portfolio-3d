import React from "react";

const SettingsContext = React.createContext<{
  settings: object;
  setSettings: React.Dispatch<React.SetStateAction<object>>;
} | null>(null);

export default SettingsContext;
