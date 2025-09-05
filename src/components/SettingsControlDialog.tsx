import React from "react";
import SettingsContext from "../contexts/SettingsContext";
import { Slider } from "@mui/material";

const useSettings = () => {
  const settingsContext = React.useContext(SettingsContext);
  if (!settingsContext) {
    throw new Error("No settings provider");
  }

  return settingsContext;
};

type InternalSettings = {
  [K: string]: {
    value: number;
    baseValue: number;
    min: number;
    max: number;
    step: number;
  };
};

const getSliderParameters = (startValue: number) => {
  const min = startValue - Math.abs(startValue);
  const max = startValue + Math.abs(startValue);
  const step = Math.abs(startValue / 5);

  return { min, max, step };
};

const SettingsControlDialog = () => {
  const { setSettings, settings } = useSettings();

  const internalSettings = React.useMemo(
    () =>
      Object.entries(settings).reduce(
        (prev, [k, v]) => ({
          ...prev,
          [k]: {
            value: v,
            baseValue: v,
            ...getSliderParameters(v),
          },
        }),
        {} as InternalSettings,
      ),
    [settings],
  );

  const onValueChange = React.useCallback(
    (key: string, value: number) =>
      setSettings((obj) => ({ ...obj, [key]: value })),
    [],
  );

  return (
    <div className="fixed top-20 right-20 bg-white z-50 p-2 rounded-sm">
      <div className="flex flex-col w-20">
        {Object.entries(internalSettings).map(([k, v], i) => (
          <div key={i}>
            <Slider
              marks
              value={v.value}
              min={v.min}
              max={v.max}
              step={v.step}
              onChange={(e) => onValueChange(k, (e.target as any).value)}
            />
            <span>{v.value}</span>
          </div>
        ))}
      </div>
    </div>
  );
};

export default SettingsControlDialog;
