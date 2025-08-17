@echo off
setlocal

REM Set your upload folder
set "UPLOAD_DIR=drakiverse"

REM Move to repo root
cd /d "%~dp0"

REM Add files to Git
git add -f %UPLOAD_DIR%
git commit -m "Upload new assets"
git push

REM Delete local copies
rmdir /s /q %UPLOAD_DIR%
mkdir %UPLOAD_DIR%

echo Upload complete and local files removed.
