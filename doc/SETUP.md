# Setup

## Base

```sh
npm create vite@latest
rimraf eslint.config.js
npm uninstall @eslint/js eslint-plugin-react-hooks eslint-plugin-react-refresh typescript-eslint
npm i -D prettier
```

## Tailwind

```sh
npm i tailwindcss 
npm i -D @tailwindcss/vite
```

```ts filename="vite.config.ts"
import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [tailwindcss()],
});
```

```css filename="index.css"
@import "tailwindcss";
```

## TS imports

```sh
npm i -D path
```

```json filename="tsconfig.json"
 {
   "compilerOptions": {
     "baseUrl": ".",
     "paths": {
       "@/*": ["src/*"]
     }
   }
 }
```

```ts filename="vite.config.ts"

```

## ThreeJS

```sh
npm i @react-three/drei @react-three/fiber three r3f-perf leva
npm i -D @types/three
```

```ts filename="vite.config.ts"
export default defineConfig({
  assetsInclude: ["**/*.exr", "**/*.hdr", "**/*.glb", "**/*.gltf"],
});
```

```ts filename="vite-env.d.ts"
declare module "*.frag" {
    const src: string;
    export default src;
}

declare module "*.vert" {
    const src: string;
    export default src;
}

declare module "*.gltf" {
    const src: string;
    export default src;
}

declare module "*.glb" {
    const src: string;
    export default src;
}

declare module "*.exr" {
    const src: string;
    export default src;
}

declare module "*.hdr" {
    const src: string;
    export default src;
}
```
