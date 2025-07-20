# Grass - First version

The first version of the grass will have less constraints to be available quicker. We will change that later.

Will be designed in shaders (not blender).

[SimonDev grass tutorial](https://www.youtube.com/watch?v=bp7REZBV4P4)
[Procedural Grass in 'Ghost of Tsushima'](https://www.youtube.com/watch?v=bp7REZBV4P4)

## Requirements

- Need to look right (no sh** ..)
- Movement and animation (tweekable wind, realist)

## Implementation

### Single blade

**Instancing**: technique to render many instances of the same thing -> GPU draws many times with one call (one mesh) (positions and indices)

**Instance data**: changes between each instances (offset data)

Each vertex of the mesh needs position in this case.

**Possible to get rid of positions** -> we use the indices to derive positions from there.

We put every index with even number on the left, every index with odd number on the right -> **X component**  
**Y component**: divide height by 2 (rounded).

<img src="/public/doc/grass-index.png" width="400"></img>
