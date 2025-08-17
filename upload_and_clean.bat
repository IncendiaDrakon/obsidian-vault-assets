@echo off
setlocal

REM ───────────────────────────────────────────────────────────────
REM CONFIG
set "UPLOAD_DIR=drakiverse"
set "TMP_LIST=%TEMP%\tracked_assets.txt"
REM ───────────────────────────────────────────────────────────────


REM 1) Jump to repo root
cd /d "%~dp0"

REM 2) Capture the list of *currently tracked* assets
git ls-files "%UPLOAD_DIR%" > "%TMP_LIST%"

REM 3) Stage ONLY brand-new files (no deletions!)
for /F "usebackq delims=" %%F in (`dir /B /S "%UPLOAD_DIR%\*" 2^>nul`) do (
  git add -f "%%F"
)

REM 4) Commit + push your additions
git commit -m "Upload new assets"
git push

REM 5) Update .gitignore so future changes in %UPLOAD_DIR% are ignored
findstr /C:"%UPLOAD_DIR%/" .gitignore >nul 2>&1 || (
  echo %UPLOAD_DIR%/>>.gitignore
  git add .gitignore
  git commit -m "Ignore %UPLOAD_DIR% locally"
  git push
)

REM 6) Tell Git to skip-worktree for every file we captured in step 2
for /F "usebackq delims=" %%F in ("%TMP_LIST%") do (
  git update-index --skip-worktree "%%F"
)
del "%TMP_LIST%"

REM 7) Finally, delete the local folder and recreate it empty
rmdir /S /Q "%UPLOAD_DIR%" 2>nul
mkdir "%UPLOAD_DIR%"

echo.
echo =====
echo Upload complete.
echo - New files pushed.
echo - Old and new assets remain on GitHub.
echo - Local folder cleaned; Git will now ignore deletions.
echo =====
