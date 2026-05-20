# Pong Hackathon

Started as a hackathon challenge: a single-file Pong where the AI paddle did
nothing. The AI has since been built out into a human-like opponent across
~14 atomic commits. `git log --oneline` reads as a design diary.

## How the game runs

Open `index.html` in a browser. No build step, no server, no dependencies.

- Left paddle: you (W/S or ↑/↓)
- Right paddle: AI
- Space: start round / continue
- First to 7 wins

Difficulty selector (Easy / Medium / Hard) sits below the canvas.

## File map

Everything lives in `index.html`. Sections are marked with `// ─── HEADER ───`:

| Section | What it does |
|---------|--------------|
| CONSTANTS | Speed, size, score limit |
| SETUP | Canvas init |
| GAME STATE | Position / velocity vars |
| AI DIFFICULTY | Selector state and listeners |
| AUDIO | Web Audio tone helpers (`blip`, `chirp`) |
| INPUT | Keyboard handlers |
| ROUND / GAME MANAGEMENT | Round start / reset |
| PLAYER MOVEMENT | Reads keys, moves left paddle |
| BALL PHYSICS | Movement, wall and paddle bounces, scoring |
| **AI MOVEMENT** | `getAiMove` — the substantial bit |
| DRAWING | Canvas rendering |
| GAME LOOP | `requestAnimationFrame` driver |

## AI architecture

Four stacked layers of human-like imperfection. The detailed architecture
comment lives directly above `getAiMove` in `index.html` — read that for the
full picture. Summary:

1. **Perception** — reaction-delayed ball state via a ring buffer
2. **Prediction** — linear extrapolation to landing-y (incoming) or contact-y
   (anticipation). No wall-bounce modelling — out-of-bounds landings clamped.
3. **Skill profile** — per-rally variance (`SKILL_LAPSE` / `SKILL_DEFAULT` /
   `SKILL_SHARP`). `DIFFICULTY_DISTRIBUTIONS` controls the mix per level.
4. **Motor** — direction-switch stutter and stop-overshoots.

The skill profile is the dominant source of variation. Each rally samples a
profile and inherits its reaction lag, noise, persistent y-bias, etc., for
the whole rally. Difficulty changes the *mix*, not the underlying parameters
— Hard plays more sharp rallies and fewer lapses; Easy is the opposite.

## Known limitations

- **Frame-rate dependence.** All movement and all AI timing is in
  pixels-per-frame / frames-of-delay, tuned at ~60 fps. On 120/144 Hz
  displays the game runs proportionally faster and the AI's reaction-lag
  values map to shorter wall-clock times. Fix would require a `dt`-based
  loop and re-tuning every reaction-frame count in the skill profiles.
- **No wall-bounce prediction.** `predictLandingY` is linear; landings
  outside `[0, H]` are clamped instead of reflected. Sharp vertical returns
  exploit this — useful exploit for human players, intentional handicap on
  the AI.

## Common ways to extend

- **Visual polish.** Ball trail, glow, paddle hit-flash, particle puff on
  scoring. All in the DRAWING section.
- **Wall-bounce predictor.** Extend `predictLandingY` to fold reflections
  off the top/bottom walls into the landing-y estimate. Removes the
  vertical-return exploit.
- **Player-tendency learning.** Running histogram of where the player tends
  to return the ball; bias the anticipation phase toward those zones.
- **Rally speedup.** Existing 1.04× per-hit could be steeper or staged.
- **Frame-rate independence.** See limitations above.

## Working with Claude

Describe what you want in plain English. Paste browser-console errors (F12)
directly. The commit history is rich — `git log --oneline -20` is a fast way
to see what's been tried.

## Running Claude

```bash
./start-claude.sh    # macOS / Linux
start-claude.cmd     # Windows
```
