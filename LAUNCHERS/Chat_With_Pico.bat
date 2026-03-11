@echo off
title PicoClaw Chat

:: Ensure working directory is the repository root
cd /d "%~dp0.."
echo =========================================
echo       PicoClaw Interactive Chat
echo =========================================
echo.
echo Starting PicoClaw... (System logs are hidden for a clean experience)
echo To exit, type: exit
echo.

:: We redirect stderr (2>nul) to hide the [INFO] and [ERROR] logger messages,
:: leaving only the clean stdout containing the chat interface.
.\LAUNCHERS\Prebuilt\picoclaw.exe agent 2>nul

pause
