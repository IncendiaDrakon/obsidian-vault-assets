@echo off
setlocal

REM Set your upload folder
set "UPLOAD_DIR=drakiverse"

REM Move to repo root
cd /d "%~dp0"

REM Step 1: Add and commit new files
git add -f "%UPLOAD_DIR%"
git commit -m "Upload new assets"
git push

REM Step 2: Add folder to .gitignore if not already present
findstr /C:"%UPLOAD_DIR%/" .gitignore >nul 2>&1 || (
    echo %UPLOAD_DIR%/>>.gitignore
    git add .gitignore
    git commit -m "Update .gitignore to exclude %UPLOAD_DIR%"
    git push
)

REM Step 3: Delete local folder (files stay on GitHub)
rmdir /s /q "%UPLOAD_DIR%"
mkdir "%UPLOAD_DIR%"

echo Upload complete. Files pushed to GitHub and removed locally.
