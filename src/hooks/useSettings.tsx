import React from "react";
import SettingsContext from "../contexts/SettingsContext";

const useSettings = <T extends object>(values: T): T => {
  const settingsContext = React.useContext(SettingsContext);
  if (!settingsContext) {
    throw new Error("No settings provider");
  }

  const { settings, setSettings } = settingsContext;

  setSettings((old) => ({ ...values, ...old }));

  return settings as T;
};

export default useSettings;
