import React from "react";
import SettingsContext from "../contexts/SettingsContext";
import Slider from "./Slider";
import type { Setting } from "../hooks/useSettings";

const useSettings = () => {
  const settingsContext = React.useContext(SettingsContext);
  if (!settingsContext) {
    throw new Error("No settings provider");
  }

  return settingsContext;
};

const isSettingType = (v: unknown): v is Setting<any> => {
  return typeof v === "object" && v !== null && "value" in v;
};

const SettingsControlDialog = () => {
  const { setSettings, settings } = useSettings();

  const onValueChange = React.useCallback(
    (key: string, value: number) =>
      setSettings((obj) => ({ ...obj, [key]: value })),
    [],
  );

  return (
    <div className="fixed top-20 right-20 bg-white z-50 p-2 rounded-sm">
      <div className="flex flex-col">
        {Object.entries(settings).map(([k, v], i) => (
          <div key={i} className="flex gap-2">
            <span>{isSettingType(v) ? v.label : k}</span>
            <Slider
              value={isSettingType(v) ? v.value : v}
              onChange={(v) => onValueChange(k, v)}
            />
            <span className="w-8">{isSettingType(v) ? v.value : v}</span>
          </div>
        ))}
      </div>
    </div>
  );
};

export default SettingsControlDialog;
