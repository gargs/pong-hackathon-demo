# Code review — 2026-05-20

Snapshot review of `index.html` at commit `7bd528b`. Scope: the single-file
Pong game (~830 lines, HTML + CSS + JS in one file). Not in scope: the
hackathon doc files in this directory, which are upstream artifacts.

This is a snapshot — findings may be obsolete if the code has changed
since the date above.

## Executive summary

The codebase has essentially no external attack surface (no network calls,
no persistence, no untrusted input, no external resources) so the risk
profile is genuinely low. Findings below are mostly *defensive*
recommendations, code-quality observations, and edge cases worth knowing
about — not bugs in flight.

## Security

| Concern | Status |
|---|---|
| XSS via `innerHTML` | One use in `refreshControlsLabel` (around line 265). String interpolation with a static boolean-derived value, no user input. **Safe today, brittle pattern.** See [Recommendation 1](#recommendations). |
| `eval` / `Function` / `setTimeout(string)` / `document.write` | None. |
| `fetch` / `XMLHttpRequest` / `WebSocket` / `postMessage` | None. No network attack surface. |
| `localStorage` / `sessionStorage` / cookies | None. No client-side state to manipulate. |
| User input handling | Keyboard events read `e.key` against literal strings; touch events read `clientY` (used numerically). No injection vectors. |
| External resources | None. No CDN scripts, no remote images, no fonts. |
| Cryptographic primitives | None used. `Math.random` in AI variance is non-security. |
| Mixed content / HTTPS | Served via GitHub Pages HTTPS. No `http://` references in code. |

## Correctness

1. **Float precision in trajectory prediction.** `predictLandingY` guards
   `b.vx <= 0`, but not "very small but positive". If `vx` were to
   approach zero, predicted time-to-arrival would explode and predicted Y
   could be a huge out-of-range number. `noisyTarget` clamps to canvas
   bounds so it doesn't crash, but the AI may briefly behave oddly.
   In practice `ball.vx` is always ≥ ~3 (the 1.04× hit boost only grows
   it from initial `BALL_SPEED = 5`), so this is theoretical today.

2. **`DIFFICULTY_DISTRIBUTIONS` weights must sum to 1.0.** All three
   distributions sum to 1.0 today. There's a `return SKILL_DEFAULT`
   fallback in `sampleSkill` so a typo would degrade gracefully. See
   [Recommendation 2](#recommendations).

3. **AudioContext lifecycle.** Created once per page load and reused.
   If the page is backgrounded for a long time on iOS, Safari may
   suspend the context; `unlockAudio` re-resumes on next gesture.
   Untested for very long sessions but should be fine.

4. **`ballHistory` is shared closure state across rallies.** Survives
   round resets. The `teleported` detection handles position jumps
   cleanly, but it means perception during the first frame of a new
   rally uses 16-frame-old state from the previous rally. Practically
   invisible.

## Code quality

1. **One `innerHTML` write.** See [Recommendation 1](#recommendations).
2. **Constants are scattered.** Some at top of the script (`W`, `H`,
   `PADDLE_W`), some inside the `getAiMove` closure (skill profiles),
   some in the polish state block. The split is sensible (closure-
   private things live in their closures), but navigation requires grep.
3. **`refreshGameActionButtons()` is called every frame** from `draw()`.
   It does idempotent DOM writes (`textContent`, `classList.toggle`,
   `disabled`); modern browsers no-op same-value writes. Slight waste,
   not a real perf issue.
4. **Duplicate CSS button styles** for `#difficulty button` and
   `#game-actions button` — near-identical. Could be consolidated under
   a shared class.

## Performance

Nothing concerning.

- ~60 fps game loop with simple math and bounded buffers.
- DOM writes per frame are idempotent and minimal.
- Audio nodes are created fresh per blip; modern browsers handle this
  fine, no need to pool.

## Accessibility

| Item | Status |
|---|---|
| `prefers-reduced-motion` honoured for paddle hit-flash and score-side wash | Done |
| Canvas is opaque to screen readers | Out of scope — making the game AT-playable is a bigger project |
| Colour-vision: orange / teal score-side wash | OK — colour is supportive, the score number is load-bearing |
| Keyboard focus released after button clicks (`.blur()`) so Space still works | Done |
| `#touchpad` has no ARIA role / label | See [Recommendation 3](#recommendations) |

## Browser compatibility

- `aspect-ratio` CSS: Safari 15+ / Chrome 88+ / Firefox 89+. Fine for
  "modern browser".
- `clamp()`, `pointer: coarse`, `performance.now()`,
  `requestAnimationFrame`: universal.
- WebKit audio prefixes handled (`window.AudioContext ||
  window.webkitAudioContext`).
- All listeners use modern syntax; no IE compat code (intentional).

## Recommendations

1. **Convert the `innerHTML` controls label to `textContent` with a
   span.** ~10 minutes. Removes the only XSS-shaped pattern in the
   file. Defensive against a future change that lets user input flow
   into that string.
2. **Add a one-line comment near `DIFFICULTY_DISTRIBUTIONS`** noting
   "weights must sum to 1.0". Trivial.
3. **(Optional)** Add `role="slider" aria-label="Paddle position"` to
   `#touchpad`. ~10 seconds. Helps screen readers describe the input.
4. **(Skip)** Everything else. Code is in good shape for the project's
   scope.
