@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Scripts\GenerateSoundBanks.ps1" %*
set "bankExitCode=%errorlevel%"
pause
exit /b %bankExitCode%
