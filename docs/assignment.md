# Assignment: Build a Pong AI

## The game

You have a working Pong game. Open `index.html` in your browser and try it out — you'll quickly notice that the AI opponent does absolutely nothing.

Your job: make it play.

## The challenge

Find the `getAiMove` function in `index.html` (look for the **AI MOVEMENT** section). It currently returns `0`, which means "don't move". Make it return `-1` (move up) or `1` (move down) at the right moments, based on the game state it receives.

The `gameState` object contains the ball position, ball velocity, and both paddle positions — everything you need.

**Ask Claude for help.** That's the whole point. Describe what you want in plain English and work through it together.

## What good looks like

By the end of the session you should have an AI that:
- Actually plays (moves to intercept the ball)
- Is beatable by a human player
- Feels like a fair opponent — not a pushover, not impossible

How you get there is up to you.

## Going further

Once your AI works, pick whatever interests you:

- **Difficulty levels** — add an Easy / Medium / Hard selector that changes how smart or fast the AI is
- **Better AI** — instead of just following the ball, predict where it will land
- **Visual polish** — glow effects, colour themes, particle effects on scoring
- **Audio** — add sound effects using the Web Audio API (no files needed, Claude can generate tones in code)
- **Rally speedup** — make the ball get faster during a long rally
- **Scoreboard** — track wins across multiple games

There's no prescribed order and no wrong answer. Follow your curiosity.

## Debrief

At the end we'll look at what everyone built. Be ready to show your game and explain one thing you learned or found surprising.
