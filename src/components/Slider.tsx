import { Slider as MuiSlider } from "@mui/material";
import React from "react";

const getSliderParameters = (startValue: number) => {
  const min = startValue - Math.abs(startValue);
  const max = startValue + Math.abs(startValue);
  const step = Math.abs(startValue / 5);

  return { min, max, step };
};

export type SliderProps = {
  value: number;
  onChange?: (v: number) => void;
};

const Slider = ({ value, onChange }: SliderProps) => {
  const options = React.useMemo(() => getSliderParameters(value), []);

  return (
    <MuiSlider
      marks
      value={value}
      min={options.min}
      max={options.max}
      step={options.step}
      onChange={(e) => onChange?.((e.target as any).value)}
    />
  );
};

export default Slider;
