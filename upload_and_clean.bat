@echo off
setlocal

REM Set your upload folder
set "UPLOAD_DIR=drakiverse"

REM Move to repo root
cd /d "%~dp0"

REM Add files to Git
git add -f "%UPLOAD_DIR%"
git commit -m "Upload new assets"
git push

REM Stop tracking the folder locally but keep it on GitHub
git rm --cached -r "%UPLOAD_DIR%"
git commit -m "Stop tracking local folder"
git push

REM Add folder to .gitignore if not already present
findstr /C:"%UPLOAD_DIR%/" .gitignore >nul 2>&1 || echo %UPLOAD_DIR%/>>.gitignore

REM Delete local copies
rmdir /s /q "%UPLOAD_DIR%"
mkdir "%UPLOAD_DIR%"

echo Upload complete. Files pushed to GitHub and removed locally.
