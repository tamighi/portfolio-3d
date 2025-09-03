import React from "react";

export type SettingsContextType = {
  settings: object;
  setSettings: React.Dispatch<React.SetStateAction<object>>;
};

const SettingsContext = React.createContext<SettingsContextType | null>(null);

export default SettingsContext;
