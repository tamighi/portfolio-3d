# Models

## Import

```tsx
import { mountainModel } from "@/assets";
import { useLoader } from "@react-three/fiber";
import { GLTFLoader } from "three/examples/jsm/Addons.js";

const Mountain = () => {
  const model = useLoader(GLTFLoader, mountainModel);

  return <primitive object={model.scene} />;
};

export default Mountain;
```

## Export blender

File > Export > glTF 2.0 (.glb/.gltf)

glTF binary if no texture + smallest possible file

If no textures -> no need UV's

No normal for lightning to work

Compression for Draco compression (need Draco loader)
