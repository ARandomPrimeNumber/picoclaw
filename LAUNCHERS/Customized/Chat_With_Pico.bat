@echo off
title PicoClaw Chat
echo =========================================
echo       PicoClaw Interactive Chat
echo =========================================
echo.
echo Starting PicoClaw... (System logs are hidden for a clean experience)
echo To exit, type: exit
echo.

:: We redirect stderr (2>nul) to hide the [INFO] and [ERROR] logger messages,
:: leaving only the clean stdout containing the chat interface.
.\picoclaw.exe agent 2>nul

pause
