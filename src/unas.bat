:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author: chuan
:: Date: 2023.11.23
:: Description: restore original data
:: Usage: nas.bat
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off

Setlocal enabledelayedexpansion

set reset=[0m
set red=[31m
set yellow=[33m


>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" && (
    echo.
) || (
    powershell Start-Process %0 -Verb RunAs > nul
    IF ERRORLEVEL 1 (
        cls
        echo ====================================================================================================
        echo ^|%red% NOTE: Please ensure that the BAT file is run from the desktop directory.%reset%                         ^|
        echo ^|%yellow%        Or Run As Administrator.%reset%                                                                  ^|
        echo ====================================================================================================
    )
    echo Press any key to exit...
    pause > nul
    exit /b
)

set serviceName=LanmanServer
for /f "tokens=2 delims=: " %%a in ('sc qc %serviceName% ^| find "START_TYPE"') do (
    set startType=%%a
)

sc start %serviceName%
sc config %serviceName% start= auto

schtasks /delete /tn "nas" /f

netsh interface portproxy delete v4tov4 listenaddress=127.0.0.1 listenport=445
cmdkey /delete 127.0.0.1

pause