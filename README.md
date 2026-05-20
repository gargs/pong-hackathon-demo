# Pong, with a human-feeling AI

A single-file browser Pong game with an AI opponent designed to feel like a
real person on the other side — it reads the ball, makes mistakes, varies
its play from rally to rally, and is beatable.

Built during the Anthropic × Sportlink hackathon.

## Try it

Drop `index.html` into any modern browser and press Space.

```bash
git clone git@github.com:sportlinkservices/pong-hackathon-gargs.git
cd pong-hackathon-gargs
open index.html        # macOS
```

> **Safari + sound:** Safari blocks the Web Audio API on `file://` URLs even
> after a user gesture. If you want audio in Safari, serve over HTTP:
> ```bash
> python3 -m http.server 8000
> ```
> then open `http://localhost:8000/`. Chrome and Firefox work fine over
> `file://`.

## Controls

| Key | Action |
|---|---|
| `W` / `S` or `↑` / `↓` | Move your paddle |
| `Space` | Start round / continue after a point |
| `P` | Pause / resume |
| `M` | Mute / unmute audio |
| Click Easy / Medium / Hard | Change AI difficulty |

First to 7 points wins.

## How the AI works

Four stacked layers of human-like imperfection:

1. **Perception** — the AI plans against the ball as it was 5–16 frames ago,
   not as it is now (reaction lag).
2. **Prediction** — linear extrapolation of where the ball will arrive at
   the AI's x. While the ball is heading away, the AI predicts where it
   will arrive on the player's side and pre-positions (one-ply lookahead).
3. **Skill profile** — at the start of each rally the AI samples a profile:
   *lapse* (sluggish, big persistent y-bias), *default* (peer-level), or
   *sharp* (fast, accurate). The profile drives reaction lag, read noise,
   anticipation commitment and motor parameters for the whole rally.
4. **Motor model** — humans can't reverse direction instantly and often hold
   a press one or two frames past the optimal stop. Direction-switch
   stutter and overshoot counters model this.

**Difficulty** changes which profiles get sampled, not their internal
parameters. Easy is mostly lapses, Medium is balanced, Hard is mostly sharp.

For the detailed architecture, see the comment above `getAiMove` in
`index.html`.

## Known limitations

- **Frame-rate dependent.** All movement is in pixels per frame, tuned at
  ~60 fps. On a 120/144 Hz display the game runs proportionally faster.
- **No wall-bounce prediction.** The trajectory predictor is linear;
  vertical returns that bounce off the top/bottom walls fool the AI.
  Useful exploit for human players, intentional handicap on the AI.

## The journey

The AI evolved across ~18 atomic commits from a naive ball-follower to the
layered model above. `git log --oneline` reads as a design diary:

```
naive ball-following AI
add dead zone to stop paddle jitter
cap effective AI speed to make it beatable
replace random skip with reaction delay
target-based control for human-like key holds
phase-driven control with discrete decision events
keep refining read during flight instead of going dormant
anticipate the return during the recovery phase
hedge anticipation toward centre instead of fully committing
motor imprecision — direction-switch pause and overshoots
per-rally skill variance to break the unbeatable wall
difficulty selector wired into per-rally skill distribution
synthesized sound effects via Web Audio API
mute (M) and pause (P)
subtle paddle hit-flash and score-side wash
Safari-friendly Web Audio unlock
```

Each commit is small and self-contained, so any individual layer can be
reverted without breaking the rest.

## File map

| File | What it is |
|---|---|
| `index.html` | The entire game — HTML, CSS, JS, AI, all in one file |
| `CLAUDE.md` | Orientation guide for future Claude sessions opening this repo |
| `docs/assignment.md` | Original hackathon challenge brief |
| `docs/preflight.md` | What to set up before a hackathon session |
| `docs/code-review.md` | Snapshot review and open recommendations (2026-05-20) |
| `docs/session-summary.md` | Debrief-ready summary of how we approached the problem (2026-05-20) |
| `system-prompt.md` | Coaching prompt Claude uses during the session |

## Built with

- [Claude Code](https://claude.ai/code) — pair programming throughout
- Web Audio API for sound (no audio files)
- Canvas 2D for rendering
- No build step, no dependencies, no server
