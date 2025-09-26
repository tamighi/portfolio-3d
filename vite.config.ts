import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react";
import fs from "fs";
import path from "path";
import { defineConfig } from "vite";
import glsl from "vite-plugin-glsl";

const linkedLibPath = fs.realpathSync(
  path.resolve("node_modules/@tamighi/reco-panel"),
);

export default defineConfig({
  plugins: [glsl(), react(), tailwindcss()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  base: "/portfolio-3d",
  server: {
    fs: {
      allow: [".", path.resolve(__dirname, linkedLibPath)],
    },
  },
});
