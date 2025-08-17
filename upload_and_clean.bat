@echo off
setlocal enabledelayedexpansion

REM ─────────────────────────────────────────────────────────────────────────────
REM CONFIG
set "UPLOAD_DIR=drakiverse"
REM ─────────────────────────────────────────────────────────────────────────────

REM 1) cd into repo root
cd /d "%~dp0"

REM 2) Unskip any previously skipped files so we can stage new ones
for /f "delims=" %%F in ('git ls-files -- "%UPLOAD_DIR%/*"') do (
  git update-index --no-skip-worktree "%%F" 2>nul
)

REM 3) Stage & push your new assets
git add -f "%UPLOAD_DIR%"
git commit -m "Upload new assets"
git push

REM 4) Ensure future files in this folder stay untracked
findstr /x /c:"%UPLOAD_DIR%/" .gitignore >nul 2>&1 || (
  echo %UPLOAD_DIR%/>>.gitignore
  git add .gitignore
  git commit -m "Ignore %UPLOAD_DIR%/"
  git push
)

REM 5) Tell Git to completely ignore future changes (incl. deletions)
for /f "delims=" %%F in ('git ls-files -- "%UPLOAD_DIR%/*"') do (
  git update-index --skip-worktree "%%F" 2>nul
)

REM 6) Wipe out local copy and re-create folder
rmdir /s /q "%UPLOAD_DIR%"
mkdir "%UPLOAD_DIR%"

echo.
echo Upload complete!
echo - Files are on GitHub.
echo - Local folder cleaned.
echo - Future changes to %UPLOAD_DIR%/ will be ignored.
