import { useFrame, useThree } from "@react-three/fiber";
import { useRef } from "react";

const usePerfLogger = (interval = 2000) => {
  const { gl } = useThree();
  const frameCount = useRef(0);
  const lastTime = useRef(performance.now());

  useFrame(() => {
    frameCount.current++;
    const now = performance.now();
    const delta = now - lastTime.current;

    if (delta >= interval) {
      const fps = (frameCount.current * 1000) / delta;
      const info = gl.info.render;

      console.log(
        `[Perf] FPS: ${fps.toFixed(1)} | Draw Calls: ${info.calls} | Triangles: ${info.triangles}`,
      );

      frameCount.current = 0;
      lastTime.current = now;
    }
  });
};

export default usePerfLogger;
