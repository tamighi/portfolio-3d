import React from "react";
import SettingsContext from "../contexts/SettingsContext";

type SettingType = number;

export type Setting<T extends SettingType> = {
  value: T;
  label?: string;
};

type Settings = { [K: string]: SettingType | Setting<SettingType> };

type SettingsReturn<T extends Settings> = {
  [K in keyof T]: T[K] extends Setting<any> ? T[K]["value"] : T[K];
};

const useSettings = <T extends Settings>(values: T): SettingsReturn<T> => {
  const settingsContext = React.useContext(SettingsContext);
  if (!settingsContext) {
    throw new Error("No settings provider");
  }

  const { settings, setSettings } = settingsContext;

  React.useEffect(() => {
    setSettings((old) => ({ ...values, ...old }));
  }, []);

  return settings as SettingsReturn<T>;
};

export default useSettings;
