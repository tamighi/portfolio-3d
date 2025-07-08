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
