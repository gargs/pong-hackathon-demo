@echo off
if "%GITHUB_TOKEN%"=="" (
  gh auth status >nul 2>&1
  if %ERRORLEVEL%==0 (
    for /f %%i in ('gh auth token') do set GITHUB_TOKEN=%%i
  ) else (
    echo ERROR: Not logged in to GitHub CLI.
    echo Run "gh auth login" first.
    exit /b 1
  )
)

set SCRIPT_DIR=%~dp0
claude --system-prompt-file "%SCRIPT_DIR%system-prompt.md"
