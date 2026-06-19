@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM ============================================================
REM   deploy - one click, any folder, any platform
REM   Firebase / Vercel / Netlify / GitHub Pages
REM   GitHub Pages: can install GitHub CLI, create the repo,
REM   connect, upload and deploy - all in one run.
REM   (Korean guide: see the .txt file next to this script)
REM ============================================================

echo ============================================
echo   Deploy Helper
echo   Folder: %cd%
echo ============================================
echo.

set "HAS_FIREBASE="
set "HAS_VERCEL="
set "HAS_NETLIFY="
set "HAS_GHPAGES="
if exist "firebase.json"  set "HAS_FIREBASE=1"
if exist ".firebaserc"    set "HAS_FIREBASE=1"
if exist "vercel.json"    set "HAS_VERCEL=1"
if exist "netlify.toml"   set "HAS_NETLIFY=1"
if exist ".git"           set "HAS_GHPAGES=1"

echo Detected in this folder:
if defined HAS_FIREBASE echo   [Firebase]     firebase.json / .firebaserc
if defined HAS_VERCEL   echo   [Vercel]       vercel.json
if defined HAS_NETLIFY  echo   [Netlify]      netlify.toml
if defined HAS_GHPAGES  echo   [GitHub Pages] git repo
echo.

echo Choose a platform:
echo   1) Firebase Hosting
echo   2) Vercel
echo   3) Netlify
echo   4) GitHub Pages
echo   5) Cancel
echo.
set /p CHOICE="Enter number (1-5): "
echo.

if "%CHOICE%"=="1" goto firebase
if "%CHOICE%"=="2" goto vercel
if "%CHOICE%"=="3" goto netlify
if "%CHOICE%"=="4" goto ghpages
goto cancel

:firebase
echo --- Deploying to Firebase Hosting ---
where firebase >nul 2>nul || (
  echo Firebase CLI not found. Installing now ^(npm install -g firebase-tools^)...
  call npm install -g firebase-tools
)
where firebase >nul 2>nul || (echo [x] Could not install Firebase CLI. Install Node.js first: https://nodejs.org && goto end)

REM make sure we are logged in to Firebase
call firebase projects:list >nul 2>nul || (
  echo You need to log in to Firebase - a browser may open. Follow the steps.
  call firebase login
)

echo.
echo You are about to deploy as this Firebase account:
call firebase login:list
set /p FBOK="Use this account? (Y = yes / N = switch to another): "
if /i "!FBOK!"=="N" (
  echo Switching account - logging out, then logging in again...
  call firebase logout
  call firebase login
)

if exist "firebase.json" goto fb_deploy

echo.
echo No firebase.json yet - setting up Firebase Hosting for this folder.
set "PUBDIR="
for %%D in (dist build public out _site docs) do (
  if not defined PUBDIR if exist "%%D\index.html" set "PUBDIR=%%D"
)
if not defined PUBDIR if exist "index.html" set "PUBDIR=."
if not defined PUBDIR set "PUBDIR=."
echo Site folder ^(public^): "!PUBDIR!"
echo.
echo Your existing Firebase projects:
call firebase projects:list
echo.
echo   1) Use an EXISTING project from the list above
echo   2) Create a NEW project
set /p FBMODE="Choose 1 or 2: "
echo.
if "!FBMODE!"=="1" goto fb_existing

REM ---- create a new project ----
set /p FBPROJ="Type a NEW unique id (lowercase/numbers/hyphens, e.g. cafe24-2026): "
if "!FBPROJ!"=="" goto end
set "FBPROJ=!FBPROJ: =-!"
echo Creating new project "!FBPROJ!" ...
call firebase projects:create "!FBPROJ!" --display-name "!FBPROJ!"
goto fb_writeconfig

:fb_existing
set /p FBPROJ="Type the existing Project ID (the 'Project ID' column): "
if "!FBPROJ!"=="" goto end
set "FBPROJ=!FBPROJ: =-!"

:fb_writeconfig
echo Using project id: "!FBPROJ!"
> .firebaserc echo {"projects":{"default":"!FBPROJ!"}}
> firebase.json echo {
>> firebase.json echo   "hosting": {
>> firebase.json echo     "public": "!PUBDIR!",
>> firebase.json echo     "ignore": ["firebase.json","**/.*","**/node_modules/**","**/*.bat","**/*.cmd","**/*.exe","**/*.ps1","**/*.vbs","**/*.sh"]
>> firebase.json echo   }
>> firebase.json echo }
echo Created firebase.json and .firebaserc.

:fb_deploy
call firebase deploy --only hosting
goto done

:vercel
echo --- Deploying to Vercel ---
where vercel >nul 2>nul || (echo [x] Vercel CLI not found. Install: npm install -g vercel && goto end)
call vercel --prod
goto done

:netlify
echo --- Deploying to Netlify ---
where netlify >nul 2>nul || (echo [x] Netlify CLI not found. Install: npm install -g netlify-cli && goto end)
call netlify deploy --prod
goto done

:ghpages
echo --- Deploying to GitHub Pages (npx gh-pages) ---
where git >nul 2>nul || (echo [x] git not found. Install from https://git-scm.com && goto end)

set "HASREMOTE="
git rev-parse --is-inside-work-tree >nul 2>nul && for /f "delims=" %%U in ('git remote get-url origin 2^>nul') do set "HASREMOTE=%%U"
if defined HASREMOTE goto gh_publish

echo.
echo This folder is not connected to GitHub yet.
where gh >nul 2>nul && goto gh_auto

REM ---- gh CLI missing: let the user choose how to proceed ----
:gh_no_cli
echo GitHub CLI (gh) is not installed. How do you want to proceed?
echo   a) Install GitHub CLI now and let me create the repo  (recommended)
echo   b) Open github.com so I can make the repo, then paste its URL
echo   c) I already have a repo URL to paste
echo.
set /p GHOPT="Choose a / b / c: "
if /i "!GHOPT!"=="a" goto gh_install
if /i "!GHOPT!"=="b" goto gh_web
if /i "!GHOPT!"=="c" goto gh_url
echo Invalid choice.
goto gh_no_cli

:gh_install
echo Installing GitHub CLI via winget ...
winget install --id GitHub.cli -e --source winget --accept-package-agreements --accept-source-agreements
REM make gh visible in THIS window (winget updates PATH only for new windows)
set "PATH=%PATH%;%ProgramFiles%\GitHub CLI;%ProgramFiles%\GitHub CLI\bin"
where gh >nul 2>nul || (
  echo.
  echo GitHub CLI is installed, but this window needs a restart to see it.
  echo Please CLOSE this window, open deploy.bat again, and choose 4 again.
  goto end
)
echo.
echo Now log in to GitHub. A browser window may open - follow the steps.
gh auth login
goto gh_auto

:gh_web
echo Opening github.com to create a new repository ...
start "" "https://github.com/new"
echo.
echo In the browser: type a repo name, keep it EMPTY (no README/license),
echo click "Create repository", then copy the URL it shows.
echo Example: https://github.com/USERNAME/REPO.git
echo.
set /p REPOURL="Repo URL (blank to stop): "
if "!REPOURL!"=="" goto end
call :gitinit
git remote add origin "!REPOURL!"
git push -u origin main
set "FIRSTTIME=1"
goto gh_publish

:gh_url
set /p REPOURL="Repo URL (blank to stop): "
if "!REPOURL!"=="" goto end
call :gitinit
git remote add origin "!REPOURL!"
git push -u origin main
set "FIRSTTIME=1"
goto gh_publish

:gh_auto
echo GitHub CLI is ready.
echo Checking GitHub login ...
gh auth status >nul 2>nul && goto gh_makerepo
echo.
echo ==========================================================
echo   GitHub login needed - ONE TIME ONLY
echo   * A one-time CODE will appear just below (like 1A2B-3C4D).
echo   * The code is shown HERE in this window - NOT by email.
echo   STEP 1: copy that code.
echo   STEP 2: press Enter - your web browser will open.
echo   STEP 3: paste the code in the browser, Continue, then Authorize.
echo ==========================================================
echo.
gh auth login --hostname github.com --git-protocol https --web
gh auth status >nul 2>nul || (echo [x] Login not completed. Please run the script again. && goto end)

:gh_makerepo
set /p REPONAME="New repo name (e.g. cafe24): "
if "!REPONAME!"=="" goto end
call :gitinit
echo Creating GitHub repo and pushing...
gh repo create "!REPONAME!" --public --source=. --remote=origin --push
if errorlevel 1 (
  echo.
  echo [x] Could not create the repo. The name may already be taken - try another.
  goto end
)
set "FIRSTTIME=1"
goto gh_publish

:gh_publish
echo Looking for the folder with index.html ...
set "PUBDIR="
for %%D in (dist build public out _site docs) do (
  if not defined PUBDIR if exist "%%D\index.html" set "PUBDIR=%%D"
)
if not defined PUBDIR if exist "index.html" set "PUBDIR=."
if defined PUBDIR (
  echo Found index.html in: "!PUBDIR!"
) else (
  echo Could not auto-detect a folder with index.html.
  set /p PUBDIR="Folder to publish [dist, or . for this folder]: "
)
if not defined PUBDIR set "PUBDIR=."
if not exist "package.json" (
  echo Creating minimal package.json ^(required by gh-pages^)...
  >package.json echo {"name":"site","version":"1.0.0","private":true}
)
echo Publishing folder: "!PUBDIR!"
call npx gh-pages -d "!PUBDIR!"
if defined FIRSTTIME (
  echo.
  echo [First time only] Finish on GitHub:
  echo   Settings ^> Pages ^> Source ^> select "gh-pages" branch ^> Save.
  echo   Your site will appear at https://USERNAME.github.io/REPO/
)
goto done

:done
echo.
echo ============================================
echo   Done. If you see "Deploy complete!" or "Published"
echo   above, it worked.
echo ============================================
goto end

:cancel
echo Cancelled. Nothing deployed.

:end
echo.
pause
goto :eof

REM ---------- helper: init git, ignore node_modules, first commit ----------
:gitinit
if not exist ".gitignore" (
  >.gitignore echo node_modules/
  >>.gitignore echo .cache/
)
if not exist ".git" git init
call :setidentity
git add .
git commit -m "first commit"
git branch -M main
exit /b

REM ---- make commits show as the logged-in GitHub user (this repo only) ----
:setidentity
where gh >nul 2>nul || exit /b
gh auth status >nul 2>nul || exit /b
for /f "delims=" %%i in ('gh api user --jq .login 2^>nul') do set "GHLOGIN=%%i"
for /f "delims=" %%i in ('gh api user --jq .id 2^>nul') do set "GHID=%%i"
if defined GHLOGIN git config user.name "!GHLOGIN!"
if defined GHLOGIN if defined GHID git config user.email "!GHID!+!GHLOGIN!@users.noreply.github.com"
exit /b
