@echo off
title PicoClaw Gateway
echo =========================================
echo       PicoClaw Gateway Monitor
echo =========================================
echo.
echo Starting the PicoClaw Gateway server...
echo This window will continuously stream all system logs and event triggers.
echo Keep this window open in the background to receive hardware/API events!
echo.

:: Run the gateway directly so the user can monitor the live console logs.
.\picoclaw.exe gateway

pause
