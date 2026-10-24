Build the interface accessible, scalable, and responsive, in any framework.

- **Accessibility**: Meet WCAG 2.2 AA. Prefer native elements over ARIA; make every interaction keyboard-operable with a visible focus; pair color with text or an icon.
- **Units**: Size in rem (Tailwind scale first); reserve px for borders, outlines, rings, shadows, and blur.
- **Interactive elements**: Match the cursor to the affordance, e.g. `cursor-pointer` for clickable elements, `cursor-grab` or `cursor-grabbing` for draggable elements, `cursor-col-resize` or `cursor-row-resize` for resize handles, `cursor-not-allowed` for disabled controls.
- **Responsive design**: Use a mobile-first approach. Define base styles for small screens, then add breakpoint overrides for larger screens.
- **States**: Give every async view loading, empty, and error states.
- **Color tokens**: Color through semantic tokens (`bg-background`, `text-muted-foreground`) so themes and dark mode apply everywhere.
- **Motion**: Gate animation and transitions behind `prefers-reduced-motion` (Tailwind `motion-safe:`).
