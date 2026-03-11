@echo off
setlocal EnableDelayedExpansion
title PicoClaw TUI
color 0B

:: Define config path
set "CONFIG_PATH=%USERPROFILE%\.picoclaw\config.json"

:MainMenu
cls
echo ==============================================================================
echo.
echo     [94m____  __________  __________    ___ _       __[0m
echo    [94m/ __ \/  _/ ____/ / __ \/ ___/   /   ^| ^|     / /[0m
echo   [94m/ /_/ // // /     / / / /\__ \   / /^| ^| ^| /^| / / [0m
echo  [94m/ ____// // /___  / /_/ /___/ /  / ___ ^| ^|/ ^|/ /  [0m
echo [94m/_/   /___/\____/  \____//____/  /_/  ^|_^|__/^|__/   [0m
echo.
echo ==============================================================================
echo.
echo [95m---Config Menu---[0m

:: Fetch active model
for /f "delims=" %%I in ('powershell -NoProfile -Command "(Get-Content -Raw '%CONFIG_PATH%' | ConvertFrom-Json).agents.defaults.model_name"') do set "ACTIVE_MODEL=%%I"

echo [97m1. Model: %ACTIVE_MODEL%[0m
echo [90m2. Channel (no channel enabled)[0m
echo [90m3. Start Talk (Interactive CLI)[0m

:: Check gateway status
tasklist /FI "IMAGENAME eq picoclaw.exe" /FI "WINDOWTITLE eq PicoClaw Gateway Monitor" 2>NUL | find /I /N "picoclaw.exe">NUL
if "%ERRORLEVEL%"=="0" (
    set "GW_STATUS=[96mGateway running[0m"
    set "GW_ACTION=Stop Gateway"
) else (
    set "GW_STATUS=[90mGateway stopped[0m"
    set "GW_ACTION=Start Gateway"
)

echo [97m4. %GW_ACTION%[0m            %GW_STATUS%
echo [97m5. View Gateway Log[0m             Open gateway.log
echo [97m6. Exit[0m                         Exit the TUI
echo.
set /p "CHOICE=Select an option [1-6]: "

if "%CHOICE%"=="1" goto MenuModel
if "%CHOICE%"=="2" goto MainMenu
if "%CHOICE%"=="3" goto StartTalk
if "%CHOICE%"=="4" goto ToggleGateway
if "%CHOICE%"=="5" goto ViewLogs
if "%CHOICE%"=="6" goto End

goto MainMenu

:MenuModel
cls
echo ==============================================================================
echo [95m---Model Selection---[0m
echo.

:: Fetch all models
set "MODEL_COUNT=0"
powershell -NoProfile -Command "try { $c=ConvertFrom-Json (Get-Content -Raw '%CONFIG_PATH%'); $i=1; foreach($m in $c.model_list) { Write-Output ('{0}. {1}' -f $i, $m.model_name); $i++ } } catch { Write-Output 'Error' }" > "%TEMP%\pico_models.tmp"
for /f "delims=" %%A in (%TEMP%\pico_models.tmp) do (
    if "%%A"=="Error" (
        echo Error reading config.json!
        pause
        goto MainMenu
    )
    echo %%A
    set /a MODEL_COUNT+=1
)
del "%TEMP%\pico_models.tmp" 2>nul
set /a NEW_IDX=!MODEL_COUNT!+1
echo %NEW_IDX%. [Add New Model]
echo 0. [Back to Main Menu]
echo.
set /p "M_CHOICE=Select model [0-%NEW_IDX%] (or type E to edit an existing model): "

if /i "!M_CHOICE!"=="E" goto EditModel
if "%M_CHOICE%"=="0" goto MainMenu
if "%M_CHOICE%"=="%NEW_IDX%" goto AddModel

:: Set active model
powershell -NoProfile -Command "$c=Get-Content -Raw '%CONFIG_PATH%' | ConvertFrom-Json; $idx=%M_CHOICE%-1; if ($idx -ge 0 -and $idx -lt $c.model_list.Count) { $target=$c.model_list[$idx]; $c.agents.defaults.model_name=$target.model_name; $c.agents.defaults.model=$target.model; $c | ConvertTo-Json -Depth 10 | Set-Content '%CONFIG_PATH%' }"
goto MainMenu

:EditModel
set /p "E_IDX=Enter the number of the model you want to edit: "
powershell -NoProfile -Command "$c=ConvertFrom-Json (Get-Content -Raw '%CONFIG_PATH%'); $idx=%E_IDX%-1; if ($idx -ge 0 -and $idx -lt $c.model_list.Count) { $m=$c.model_list[$idx]; Write-Output ($m.model_name, $m.model, $m.api_base, $m.api_key, $m.proxy, $m.auth_method, $m.connect_mode, $m.workspace, $m.max_tokens_field, $m.rpm -join '|') }" > "%TEMP%\pico_model.tmp"
for /f "tokens=1-10 delims=|" %%a in (%TEMP%\pico_model.tmp) do (
    set "M_NAME=%%a"
    set "M_MOD=%%b"
    set "M_BASE=%%c"
    set "M_KEY=%%d"
    set "M_PROX=%%e"
    set "M_AUTH=%%f"
    set "M_CONN=%%g"
    set "M_WORK=%%h"
    set "M_MAX=%%i"
    set "M_RPM=%%j"
)

cls
echo ==============================================================================
echo [95m---Edit Model: %M_NAME%---[0m
echo.
echo Press ENTER to keep current value.
echo.
set /p "N_NAME=Model Name [%M_NAME%]: "
if "!N_NAME!"=="" set "N_NAME=%M_NAME%"

set /p "N_MOD=Model [%M_MOD%]: "
if "!N_MOD!"=="" set "N_MOD=%M_MOD%"

set /p "N_BASE=API Base [%M_BASE%]: "
if "!N_BASE!"=="" set "N_BASE=%M_BASE%"

set /p "N_KEY=API Key [%M_KEY%]: "
if "!N_KEY!"=="" set "N_KEY=%M_KEY%"

set /p "N_PROX=Proxy [%M_PROX%]: "
if "!N_PROX!"=="" set "N_PROX=%M_PROX%"

set /p "N_AUTH=Auth Method [%M_AUTH%]: "
if "!N_AUTH!"=="" set "N_AUTH=%M_AUTH%"

set /p "N_CONN=Connect Mode [%M_CONN%]: "
if "!N_CONN!"=="" set "N_CONN=%M_CONN%"

set /p "N_MAX=Max Tokens Field [%M_MAX%]: "
if "!N_MAX!"=="" set "N_MAX=%M_MAX%"

set /p "N_RPM=RPM [%M_RPM%]: "
if "!N_RPM!"=="" set "N_RPM=%M_RPM%"

:: Update JSON
powershell -NoProfile -Command "$c=ConvertFrom-Json (Get-Content -Raw '%CONFIG_PATH%'); $idx=%E_IDX%-1; $nm=[PSCustomObject]@{model_name='!N_NAME!'; model='!N_MOD!'; api_base='!N_BASE!'; api_key='!N_KEY!'; proxy='!N_PROX!'; auth_method='!N_AUTH!'; connect_mode='!N_CONN!'; max_tokens_field='!N_MAX!'; rpm=[int]'0!N_RPM!'}; $c.model_list[$idx]=$nm; $c | ConvertTo-Json -Depth 10 | Set-Content '%CONFIG_PATH%'"
echo Model updated!
pause
goto MainMenu

:AddModel
cls
echo ==============================================================================
echo [95m---Add New Model---[0m
echo.
set /p "N_NAME=Model Name (e.g. OpenAI GPT-4): "
set /p "N_MOD=Model (e.g. openai/gpt-4o): "
set /p "N_BASE=API Base (Optional): "
set /p "N_KEY=API Key: "
set /p "N_PROX=Proxy (Optional): "
set /p "N_AUTH=Auth Method (Optional, e.g. Bearer Token): "
set /p "N_CONN=Connect Mode (Optional): "
set /p "N_MAX=Max Tokens Field (Optional): "
set /p "N_RPM=RPM (Optional): "

if "!N_RPM!"=="" set "N_RPM=0"

:: Append to JSON
powershell -NoProfile -Command "$c=Get-Content -Raw '%CONFIG_PATH%' | ConvertFrom-Json; $nm = New-Object PSObject -Property @{model_name='!N_NAME!'; model='!N_MOD!'; api_base='!N_BASE!'; api_key='!N_KEY!'; proxy='!N_PROX!'; auth_method='!N_AUTH!'; connect_mode='!N_CONN!'; max_tokens_field='!N_MAX!'; rpm=[int]'!N_RPM!'}; $c.model_list += $nm; $c | ConvertTo-Json -Depth 10 | Set-Content '%CONFIG_PATH%'"
echo Model added successfully!
pause
goto MainMenu

:StartTalk
cls
echo Starting Interactive CLI...
echo Type 'exit' to return to menu.
.\LAUNCHERS\picoclaw.exe agent 2>nul
pause
goto MainMenu

:ToggleGateway
if "%GW_ACTION%"=="Start Gateway" (
    echo Starting Gateway...
    start "PicoClaw Gateway Monitor" cmd /c ".\LAUNCHERS\picoclaw.exe gateway > gateway.log 2>&1"
    timeout /t 2 >nul
) else (
    echo Stopping Gateway...
    taskkill /FI "WINDOWTITLE eq PicoClaw Gateway Monitor" /T /F >nul 2>&1
)
goto MainMenu

:ViewLogs
if exist gateway.log (
    start notepad gateway.log
) else (
    echo gateway.log not found! Please start the Gateway first.
    pause
)
goto MainMenu

:End
echo Goodbye!
exit /b
