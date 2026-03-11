@echo off
setlocal enabledelayedexpansion

echo =========================================
echo       PicoClaw Persona Switcher
echo =========================================
echo.
echo Enter the full path or relative path to your persona folder.
echo (Example: persona\Don Quixote)
echo.
set /p "PERSONA_DIR=Persona Folder: "

:: Remove quotes if the user dragged and dropped the folder
set "PERSONA_DIR=%PERSONA_DIR:"=%"

if not exist "%PERSONA_DIR%" (
    echo [ERROR] The folder "%PERSONA_DIR%" does not exist!
    pause
    exit /b
)

set "WORKSPACE=d:\Ye who pulled repos\picoclaw\workspace"

echo.
echo [WARNING] Changing your persona will WIPE your current sessions memory!
echo This ensures the new persona doesn't get confused by the previous persona's chat history.
echo Press Ctrl+C to cancel, or any other key to proceed.
pause

echo.
echo Clearing old session memories...
del /Q /F "%WORKSPACE%\sessions\*" 2>nul
echo [OK] Sessions memory wiped.

echo.
echo Switching persona...
echo.

:: Copy the 4 main markdown files into the workspace root
for %%F in (AGENTS.md IDENTITY.md SOUL.md USER.md) do (
    if exist "%PERSONA_DIR%\%%F" (
        copy /Y "%PERSONA_DIR%\%%F" "%WORKSPACE%\%%F" >nul
        echo [OK] Copied %%F
    ) else (
        echo [SKIP] %%F not found in persona folder.
    )
)

:: Handle MEMORY.md specifically, since it belongs in workspace\memory\
if exist "%PERSONA_DIR%\MEMORY.md" (
    copy /Y "%PERSONA_DIR%\MEMORY.md" "%WORKSPACE%\memory\MEMORY.md" >nul
    echo [OK] Copied MEMORY.md
) else if exist "%PERSONA_DIR%\memory\MEMORY.md" (
    copy /Y "%PERSONA_DIR%\memory\MEMORY.md" "%WORKSPACE%\memory\MEMORY.md" >nul
    echo [OK] Copied memory\MEMORY.md
) else (
    echo [SKIP] MEMORY.md not found in persona folder.
)

echo.
echo =========================================
echo Persona switched successfully!
echo You can now run PicoClaw.
echo =========================================
pause
