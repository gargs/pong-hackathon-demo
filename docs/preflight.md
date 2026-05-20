# Pre-flight Checklist

Please verify all of the following **before the hackathon session**. It should take about 10 minutes. If anything doesn't work, let Jeroen know ahead of time.

## Required

### A modern browser
Chrome, Firefox, Edge, or Safari — all work. Make sure it's reasonably up to date (2023 or later).

### Claude Code CLI
```bash
claude --version
```
If missing: follow the installation instructions at https://claude.ai/claude-code

You will also need an active Anthropic account with Claude Code access.

### GitHub CLI
```bash
gh --version
```
If missing:
- **macOS**: `brew install gh`
- **Windows**: `winget install GitHub.cli` (or download from https://cli.github.com)

Then log in:
```bash
gh auth login
```

### Git
```bash
git --version
```
Should already be on your machine. If not: https://git-scm.com

---

## On the day

You will receive your repository URL from Jeroen. Clone it and open the game:

```bash
git clone <your-repo-url>
cd pong-hackathon-<yourusername>
```

Open `index.html` in your browser — you should see a Pong game. Then start Claude:

```bash
./start-claude.sh    # macOS / Linux
start-claude.cmd     # Windows
```

That's it. No servers, no installs, no configuration. Everything runs in your browser.
