import React from "react";
import SettingsContext from "../contexts/SettingsContext";

const useSettings = () => {
  const settingsContext = React.useContext(SettingsContext);
  if (!settingsContext) {
    throw new Error("No settings provider");
  }

  return settingsContext;
};

const SettingsControlDialog = () => {
  const { setSettings, settings } = useSettings();

  return (
    <div className="fixed top-20 right-20 bg-red-500 flex justify-center z-50 p-2">
      <span>Hello settings</span>
      {Object.entries(settings).map(([k, v], i) => (
        <span key={i}>
          {k}: {v}
        </span>
      ))}
    </div>
  );
};

export default SettingsControlDialog;
