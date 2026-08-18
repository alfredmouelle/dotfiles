Write TypeScript that Matt Pocock and Theo Browne would be proud of: inference-first, runtime-honest, and simpler than the problem.

- **Runtime truth**: Types disappear at runtime. Validate untrusted input at the boundary; keep it `unknown` until parsed or narrowed.
- **Inference**: Let TypeScript infer local variables and implementation details. Annotate function parameters and top-level module return types; let JSX component returns infer. Use `satisfies` to check object constraints without widening their inferred types.
- **Narrowing**: Fix the model or narrow with control flow, predicates, and assertion functions. Keep `any`, non-null `!`, and unchecked `as` out of application values. `as const` is valid. When a TypeScript limitation makes an escape hatch unavoidable, isolate it in one boundary or type utility and prove the behavior with a test.
- **States**: Model variants as discriminated unions with required fields. Make impossible states unrepresentable and use `never` for exhaustive checks.
- **Source of truth**: Derive types from schemas, validators, contracts, and values when they represent the same concern. Decouple types that have independent reasons to change. Maintain one definition for each contract.
- **Generics**: Use type parameters only when they preserve a real relationship between multiple values. Prefer concrete types and readable unions over type-level cleverness.
- **Declarations**: Use `type` by default. Use `interface` when object inheritance, `extends`, or intentional declaration merging earns it.
- **Strictness**: Preserve the project's strictness. Resolve diagnostics at their cause; keep compiler and lint safeguards intact.
