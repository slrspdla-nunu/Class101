@echo off
cd /d "%~dp0"
title CLASS101 Preview Server (localhost:5500)
echo ============================================
echo   CLASS101 Preview Server
echo   URL:  http://localhost:5500/
echo.
echo   - Keep this window OPEN while previewing.
echo   - Close this window to stop the server.
echo ============================================
echo.

where python >nul 2>nul
if %errorlevel%==0 ( echo [python] serving... & python -m http.server 5500 & goto end )

where py >nul 2>nul
if %errorlevel%==0 ( echo [py] serving... & py -m http.server 5500 & goto end )

where node >nul 2>nul
if %errorlevel%==0 ( echo [node] serving... & node "%~dp0_preview-server.js" & goto end )

echo [x] Python or Node not found.
echo     Install Node.js first: https://nodejs.org
echo.

:end
pause
