@echo off
title PicoClaw Chat (DEV MODE)
echo =========================================
echo       PicoClaw Interactive Chat (DEV)
echo =========================================
echo.
echo Starting PicoClaw with FULL SYSTEM LOGS...
echo All information and error logs will be visible inline with the chat.
echo To exit, type: exit
echo.

:: We run the agent command with the --debug flag to show MAXIMUM information,
:: and we do not redirect stderr so every error and info log is printed to the screen.
.\picoclaw.exe agent --debug

pause
