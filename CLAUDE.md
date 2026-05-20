# Pong Hackathon

Welcome! Today you're going to build an AI opponent for a Pong game — entirely in your browser, no installation needed.

## How the game works

Everything lives in one file: `index.html`. Open it in your browser and you'll see a working Pong game. You (left paddle) vs. an AI opponent (right paddle) — except the AI doesn't move yet. That's your job.

To play the game while developing: just open `index.html` in your browser. Every time you save a change, refresh the page to see it.

## The code

The file is structured in sections, each clearly labelled with a comment. Here's the map:

| Section | What it does |
|---------|-------------|
| CONSTANTS | Numbers that control speed, size, score limit — easy to tweak |
| SETUP | Creates the canvas the game draws on |
| GAME STATE | Variables that track where everything is right now |
| INPUT | Listens for keyboard presses |
| ROUND / GAME MANAGEMENT | Starts and resets rounds |
| PLAYER MOVEMENT | Moves your paddle based on keys held |
| BALL PHYSICS | Moves the ball, handles bouncing and scoring |
| **AI MOVEMENT** | **← This is your challenge** |
| DRAWING | Renders everything on screen each frame |
| GAME LOOP | Runs the above ~60 times per second |

## Your challenge

Find the `getAiMove` function in the **AI MOVEMENT** section. It currently returns `0` (do nothing). Make it return `-1` (move up) or `1` (move down) based on where the ball is.

The function receives a `gameState` object — everything you need to know is in there. The comments above the function explain exactly what each property means.

### Suggested progression

1. **Get it moving** — make the AI follow the ball. Even a basic version is satisfying.
2. **Make it beatable** — a perfect AI isn't fun. Add some delay or limit how fast it reacts.
3. **Stretch goals** — pick any of these, in any order:
   - Add a difficulty selector (Easy / Medium / Hard) that changes how good the AI is
   - Make the ball speed up gradually over a long rally
   - Change the colours or add a glow effect to the ball
   - Add sound effects (ask Claude about the Web Audio API)
   - Make the AI predict where the ball will land instead of just following it

## Working with Claude

Just describe what you want in plain English. For example:

- *"Make the AI follow the ball, but with a small delay so it's not perfect"*
- *"Add a way to choose difficulty before the game starts"*
- *"Why does the ball sometimes go through the paddle?"*

Claude will explain what it's doing as it goes — ask questions freely, there are no stupid ones.

If something breaks, paste the error from the browser console (press F12 → Console tab) and ask Claude what it means.

## Running Claude

```bash
./start-claude.sh    # macOS / Linux
start-claude.cmd     # Windows
```
