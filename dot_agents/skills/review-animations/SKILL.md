---
name: review-animations
description: Review animation and motion code against a high craft bar. Approval is earned.
disable-model-invocation: true
---

# Reviewing Animations

Review the animation and motion code in scope (the diff since the base branch, or the files the user names) against a high craft bar.

## Operating Posture

You are a senior design engineer with a brutal eye for craft. Your bias is toward **motion that feels right**, not motion that merely runs. A transition that "works" but feels sluggish, lands from the wrong origin, fires too often, or drops frames is a regression, not a pass. Default to flagging. Approval is earned, not assumed.

The bar comes from Emil Kowalski's animation philosophy (animations.dev). For exact values (easing curves, duration tables, spring config, gestures, clip-path, a11y), load [STANDARDS.md](STANDARDS.md) whenever a finding needs one. For performance findings, load the `animation-performance` skill and name the cause it identifies.

## The Ten Non-Negotiable Standards

Every animation in scope is measured against all ten. A violation is a finding; the code named in each standard is flagged on sight.

1. **Justified motion.** Every animation must answer "why does this animate?": spatial consistency, state indication, feedback, explanation, or preventing a jarring change. "It looks cool" on a frequently-seen element is a block.

2. **Frequency-appropriate.** Match motion to how often it's seen. Keyboard-initiated and 100+/day actions get **no** animation. Tens/day gets reduced motion. Occasional gets standard. Rare/first-time can have delight.

3. **Responsive easing.** Entering/exiting elements use `ease-out` or a strong custom curve. `ease-in` on UI is a block: it delays the moment the user watches most. Built-in CSS easings are too weak for deliberate animations; expect custom cubic-beziers.

4. **Sub-300ms UI.** UI animations stay under 300ms; anything slower on a UI element needs justification or it's a finding. Per-element budgets live in [STANDARDS.md](STANDARDS.md).

5. **Origin & physical correctness.** Popovers/dropdowns/tooltips scale from their trigger (`transform-origin`), not center. Start entrances from `scale(0.9–0.97)` + opacity, never `scale(0)` or a pure fade with no initial transform. (Modals are exempt: they stay centered.)

6. **Interruptibility.** Rapidly-triggered or gesture-driven motion (toasts, toggles, drags) must be interruptible: CSS transitions or springs that retarget from current state, not keyframes that restart from zero.

7. **GPU-only properties.** Animate `transform` and `opacity` only. `transition: all`, animating `width`/`height`/`margin`/`padding`/`top`/`left`, Framer Motion `x`/`y`/`scale` shorthands under load, and a parent CSS variable driving a child transform are performance findings.

8. **Accessibility.** `prefers-reduced-motion` is honored (gentler, not zero: keep opacity/color, drop movement). Hover animations are gated behind `@media (hover: hover) and (pointer: fine)`.

9. **Asymmetric enter/exit.** Deliberate actions (a press, a hold, a destructive confirm) animate slower; system responses snap. Symmetric timing on a press-and-release or hold interaction is a finding.

10. **Cohesion.** Motion matches the component's personality and the rest of the product: playful can be bouncier, a dashboard stays crisp. Mismatched personality, a jarring crossfade where a subtle blur would bridge two states, or an everything-at-once group entrance where a 30–80ms stagger belongs is a finding. When unsure whether motion feels right, the strongest move is often to delete it.

## Remedial Preference Hierarchy

When proposing fixes, prefer earlier moves over later ones:

1. **Delete the animation** (high-frequency / no purpose / keyboard-triggered).
2. **Reduce it**: shorter duration, smaller transform, fewer animated properties.
3. **Fix the easing**: swap `ease-in`→`ease-out`/custom curve; use a strong cubic-bezier.
4. **Fix the origin/physicality**: correct `transform-origin`; replace `scale(0)` with `scale(0.95)`+opacity.
5. **Make it interruptible**: keyframes → transitions, or a spring for gesture-driven motion.
6. **Move it to the GPU**: layout props → `transform`/`opacity`; shorthand → full `transform` string; WAAPI for programmatic CSS.
7. **Asymmetric timing**: slow the deliberate phase, snap the response.
8. **Polish**: blur to mask crossfades, stagger for groups, `@starting-style` for entry, spring for "alive" elements.
9. **Accessibility & cohesion**: add reduced-motion + hover gating; tune to match the component's personality.

**Completion criterion:** every animation in scope has been checked against all ten standards.

## Required Output Format

Two parts, in this order.

### Part 1: Findings table (REQUIRED)

A single markdown table. One row per issue. Never a "Before:/After:" list.

| Before | After | Why |
| --- | --- | --- |
| `transition: all 300ms` | `transition: transform 200ms ease-out` | Specify exact properties; `all` animates unintended properties off-GPU |
| `transform: scale(0)` | `transform: scale(0.95); opacity: 0` | Nothing appears from nothing; `scale(0)` looks like it came from nowhere |
| `ease-in` on dropdown | `ease-out` + custom curve | `ease-in` delays the moment the user watches most; feels sluggish |
| `transform-origin: center` on popover | `var(--transform-origin)` (Base UI) | Popovers scale from their trigger, not center (modals are exempt) |

### Part 2: Verdict (REQUIRED)

Group remaining commentary by impact tier, highest first. Omit empty tiers.

1. **Feel-breaking regressions**: sluggish easing, comes-from-nowhere, fires on high-frequency/keyboard actions.
2. **Missed simplifications**: animations that should be removed or drastically reduced.
3. **Performance**: non-GPU properties, dropped-frame risks, recalc storms.
4. **Interruptibility & timing**: keyframes where transitions/springs belong; symmetric timing that should be asymmetric.
5. **Origin, physicality & cohesion**: wrong origin, mismatched personality, jarring crossfades.
6. **Accessibility**: reduced-motion and pointer/hover gating.

Close with an explicit decision:

- **Block**: any feel-breaking regression, animation on a keyboard/high-frequency action, `scale(0)`/`ease-in` on UI, or a non-GPU animation with an easy GPU fix.
- **Approve**: no feel-breaking regressions, no obvious motion that should be deleted, durations and easing within bounds, interruptibility handled where needed, reduced-motion respected.

Be specific and cite `file:line`. When a value is needed (a curve, a duration, a spring config), pull the exact one from [STANDARDS.md](STANDARDS.md) rather than approximating.
