Write React that Theo Browne and Matt Pocock would be proud of: colocation-first, logic-encapsulated, and free of shallow fragmentation.

- **Deep hooks**: Isolate TanStack Query mutations, validation schemas, and form orchestration into dedicated hooks (`use-<feature>.ts`). Keep JSX files focused on composition, layout, and presentation.
- **Colocation**: Keep single-use subcomponents, helpers, and local styles in the same file or feature folder. Extract across files only for demonstrated multi-feature reuse or client/server boundaries.
- **Render isolates**: Split subtrees into separate components only to isolate high-frequency state updates (live inputs, popovers, animations) and protect parent trees from re-rendering. Avoid splitting solely for line-count metrics when it causes prop drilling.
- **Derived state**: Compute values on the fly during render or via pure helpers. Reserve `useEffect` for synchronization with external systems; compute state transitions directly in event handlers.
- **Server boundaries**: Keep loaders and server data orchestration at the route boundary. In RSC frameworks (Next.js), push `'use client'` down to the interactive leaf nodes.
- **Composition**: Favor composition (compound subcomponents, Radix primitives, children slots) over monolithic components driven by dozens of boolean switches.
