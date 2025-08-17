@echo off
setlocal

REM ───────────────────────────────────────────────────────────────
REM CONFIGURATION
set "UPLOAD_DIR=drakiverse"
REM ───────────────────────────────────────────────────────────────

REM 1) Move to repo root
cd /d "%~dp0"

REM 2) Stage and commit only brand-new files
for /F "delims=" %%F in ('dir /B /S "%UPLOAD_DIR%\*" 2^>nul') do (
    git add -f "%%F"
)
git commit -m "Upload new assets"
git push

REM 3) Ensure drakiverse/ is in .gitignore
findstr /C:"%UPLOAD_DIR%/" .gitignore >nul 2>&1 || (
    echo %UPLOAD_DIR%/>>.gitignore
    git add .gitignore
    git commit -m "Ignore %UPLOAD_DIR% locally"
    git push
)

REM 4) Tell Git to skip-worktree on every tracked asset
for /F "delims=" %%F in ('git ls-files "%UPLOAD_DIR%"') do (
    git update-index --skip-worktree "%%F"
)

REM 5) Delete local folder and recreate it empty
rmdir /S /Q "%UPLOAD_DIR%" 2>nul
mkdir "%UPLOAD_DIR%"

echo.
echo =====
echo Upload complete.
echo - New files pushed.
echo - All assets (old & new) remain on GitHub.
echo - Local folder cleaned; Git will now ignore deletions.
echo =====
