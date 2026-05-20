# Session summary — 2026-05-20

Written at the end of the hackathon session as a debrief-ready summary of
how we approached the problem and what's notable about the approach.

## The starting point

A working Pong game in a single `index.html`, ~310 lines. The right paddle
(AI) never moved because `getAiMove()` returned `0`. The challenge: make it
play, make it beatable, make it fair. Stretch goals listed in the
assignment, no prescribed order.

## How we framed it

We didn't go directly for a great AI. We chose a different goal: make it
feel like a *peer human*, not an optimal opponent. This is a deliberately
harder problem than "build a good Pong AI" because feel is subjective and
emergent — you can't measure it with a win rate. We calibrated entirely by
play and feedback ("it feels lazy", "it feels jittery", "it taps the keys
instead of holding them"), which is closer to how real game designers
actually work.

## The iteration loop

Each commit removed one specific source of "this feels like a machine".
Always atomic, always revertable, always with a written *why* in the
commit message.

1. **Naive follow** — 5 lines, AI tracks ball-y. Unbeatable but jittery.
2. **Dead zone** — kill the per-frame oscillation.
3. **Speed cap** — random frame skips to slow effective speed below the
   player's.
4. **Reaction delay** — replace random skip with seeing the ball as it
   was ~200 ms ago. Smoother, still beatable.
5. **Target-based control** — humans don't tap keys 60×/sec; they pick a
   target and *hold* the key until they arrive.
6. **Phase-driven decisions** — read at hit, adjust mid-court, final
   tweak at the end. Discrete reads with decaying noise.
7. **Continuous micro-reads** — but the AI looked dormant between
   events. Replace discrete events with continuous re-evaluation at
   falling noise (32 px → 4 px).
8. **Anticipation during rest** — one-ply lookahead. While the ball
   heads to the player, the AI shadows the predicted contact y,
   pre-positioning for the return.
9. **Hedged anticipation** — don't fully commit to the predicted return;
   blend with centre.
10. **Motor imprecision** — stutter when reversing direction, occasional
    overshoot when stopping. Humans can't reverse a keypress instantly.
11. **Per-rally skill variance** — the unlock. At the start of each
    rally the AI samples a profile: *lapse* (sluggish, big persistent
    y-bias), *default* (peer-level), or *sharp* (fast, accurate).
    Whatever profile is rolled, the AI plays that *whole rally* with it
    — including a y-bias that lasts the full rally, which is what makes
    lapses feel like real mistakes.
12. **Difficulty selector** — three buttons wired into the *mix* of
    skill profiles, not the underlying parameters. Easy is 60% lapses;
    Hard is 40% sharp rallies.

## Then we stepped back

After the AI was in shape, we deliberately broadened scope:

- **Audio** — Web Audio synth, no files. Separate tones for player /
  AI / wall / score.
- **Visual polish** — subtle paddle hit-flash, score-side wash, both
  respecting `prefers-reduced-motion`.
- **UX** — Pause, Mute, on-screen controls.
- **Mobile** — responsive canvas, dedicated touchpad below the canvas
  with relative-anchor tracking (drag relative to where the finger
  lands, not absolute pad-Y → paddle-Y).
- **Documentation** — architecture comment above `getAiMove`, rewrite
  of `CLAUDE.md`, new `README.md`, dated code review.
- **Deployment** — live URL via GitHub Pages on a personal repo,
  dual-remote git push so the org repo and the demo repo stay in sync.

## What's remarkable about the approach

1. **Atomic-commit discipline as a design tool.** Each step was one
   logical change with a *why* in the message. The result is that the
   `git log` reads as a design diary — you can `git revert` any one
   layer and the rest still works. That's not normal hackathon hygiene.

2. **Feel-driven calibration, not metric-driven.** The AI was tuned by
   play-then-feedback loops, not by win-rate measurements. This is
   genuinely how game AI gets made.

3. **Layered model of human imperfection.** The four-layer architecture
   — perception, prediction, skill profile, motor — emerged from
   iteration but is a coherent structured way to think about human-like
   AI. Each layer maps to a different class of human limitation.

4. **The "rally as the unit of skill" insight.** The dominant variance
   lever turned out to be per-rally, not per-frame. A whole rally has a
   "vibe" — sluggish, peer, or sharp — and the AI commits to that vibe
   for the rally's duration. That's why playing against it doesn't feel
   mechanical.

5. **Engineering rigour beyond the toy.** Architecture documentation,
   code-review snapshot, accessibility (`prefers-reduced-motion`),
   mobile-playable, deployed live, dual-remote git, README + CLAUDE.md.
   The repo would survive being handed to someone else.

6. **A real-world debugging story.** Safari + `file://` + Web Audio
   combined to silently swallow audio. State was "running", code was
   correct, no sound. The fix was a local HTTP server. That's a genuine
   gotcha worth telling — and it's now documented in the README so the
   next person doesn't lose the same hour.

## Talk script (elevator pitch)

> "I built a Pong AI that's deliberately imperfect. Not optimal —
> *peer-feeling*. The AI runs four stacked layers of human imperfection,
> samples a 'skill profile' at the start of each rally, and commits to
> that profile for the whole rally. Sometimes it plays sluggishly,
> sometimes sharp. Difficulty just changes the mix. I tuned it entirely
> by play-and-feedback — there's no win-rate optimisation here. The
> `git log` reads as a design diary, one source of artificiality removed
> per commit."

Then either go technical (open `index.html` and walk the architecture
comment), or go narrative (open `git log --oneline` and walk the
journey), depending on the audience.

## What we deliberately didn't do

Named upfront to keep Q&A constructive:

- **Frame-rate independence** — documented as a known limitation in
  `README.md`. On a 144 Hz display the game runs proportionally faster.
- **Player-tendency learning** — the ML-flavoured extension. It was on
  the plan; deferred for time.
- **Three small code-review items** — open in `docs/code-review.md`.
  All defensive / nice-to-have, no bugs in flight.

These are deliberate calls, not oversights.
