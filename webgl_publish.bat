@echo off
setlocal
cd /d "%~dp0"

echo [1/6] Pull latest main...
git pull origin main
if errorlevel 1 goto :error

echo [2/6] Remove old WebGL build files...
git rm -r --ignore-unmatch Build TemplateData index.html
if errorlevel 1 goto :error

if not exist ".nojekyll" (
    type nul > .nojekyll
)

echo.
echo ==============================================
echo Build WebGL from Unity into this folder now:
echo %CD%
echo.
echo When the build is finished, press any key.
echo ==============================================
pause > nul

echo [3/6] Stage changes...
git add -A
if errorlevel 1 goto :error

echo [4/6] Current changes:
git status --short
echo.

set "COMMIT_MSG="
set /p COMMIT_MSG=Commit message (Enter = Update WebGL build): 
if "%COMMIT_MSG%"=="" set "COMMIT_MSG=Update WebGL build"

echo [5/6] Commit...
git commit -m "%COMMIT_MSG%"
if errorlevel 1 (
    echo.
    echo No commit was created. There may be no changes.
    goto :end
)

echo [6/6] Push to origin/main...
git push origin main
if errorlevel 1 goto :error

echo.
echo Done. Please check GitHub Pages in your browser.
goto :end

:error
echo.
echo An error occurred. Process stopped.
pause

:end
endlocal
