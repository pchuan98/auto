@echo off

@REM Run this bat with admin rights to delay Windows Update for 5000 days (13.7 years).

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v FlightSettingsMaxPauseDays /t reg_dword /d 5000 /f
pause