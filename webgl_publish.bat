@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo.
echo [1/6] Pull latest main...
git pull origin main
if errorlevel 1 goto :error

echo.
echo [2/6] Remove old WebGL build files...
git rm -r --ignore-unmatch Build TemplateData index.html
if errorlevel 1 goto :error

echo.
echo ============================================
echo Build WebGL from Unity into this folder now:
echo %CD%
echo.
echo When the build is finished, press Enter.
echo ============================================
set /p DUMMY=

echo.
echo [3/6] Check build files...
if not exist "Build\Build.loader.js" (
    echo ERROR: Build\Build.loader.js was not found.
    goto :error
)
if not exist "Build\Build.framework.js" (
    echo ERROR: Build\Build.framework.js was not found.
    goto :error
)
if not exist "Build\Build.data" (
    echo ERROR: Build\Build.data was not found.
    goto :error
)
if not exist "Build\Build.wasm" (
    echo ERROR: Build\Build.wasm was not found.
    goto :error
)
if not exist "index.html" (
    echo ERROR: index.html was not found.
    goto :error
)
echo Build files look OK.

echo.
echo [4/6] Add new build files...
git add .
if errorlevel 1 goto :error

echo.
echo [5/6] Commit...
git diff --cached --quiet
if not errorlevel 1 (
    echo No changes detected. Commit skipped.
    goto :success
)

git commit -m "Update WebGL build"
if errorlevel 1 goto :error

echo.
echo [6/6] Push to GitHub...
git push origin main
if errorlevel 1 goto :error

:success
echo.
echo ============================================
echo Done.
echo Push completed successfully.
echo GitHub Pages may take a little time to update.
echo Please wait a bit, then refresh with Ctrl+F5.
echo.
echo Press Enter to close this window.
echo ============================================
set /p DUMMY=
goto :end

:error
echo.
echo ============================================
echo ERROR: The process stopped before completion.
echo Please read the messages above.
echo Press Enter to close this window.
echo ============================================
set /p DUMMY=

:end
endlocal