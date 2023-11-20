:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author: chuan
:: Date: 2023.11.16
:: Description: modify the nas port number
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

cls
echo ====================================================================================================
echo %red%Using this method may cause the remote printer service to fail. Do you want to proceed?%reset%
echo ====================================================================================================
pause

set serviceName=LanmanServer
for /f "tokens=2 delims=: " %%a in ('sc qc %serviceName% ^| find "START_TYPE"') do (
    set startType=%%a
)

if /i "%startType%" NEQ "4" (
    sc stop %serviceName% > nul && sc config %serviceName% start= disabled > nul
    cls
    echo.
    echo ====================================================================================================
    echo  The service has been stopped. Please reboot the computer and run the script again.
    echo.
    echo %yellow% PLEASE REBOOT COMPUTER %reset%
    echo ====================================================================================================
    echo.

    pause
    exit /b
)

echo flushing the dns...
ipconfig /flushdns

:: delete the nas task
:: schtasks /delete /tn nas /f >nul 2>nul
schtasks /query /tn nas >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    schtasks /create /tn nas /tr "cmd /c net stop iphlpsvc && net start iphlpsvc" /sc ONSTART /ru system /f >nul 2>nul
)

echo setting the nas port number...
netsh interface portproxy add v4tov4 listenport=445 listenaddress=127.0.0.1 connectport=4450 connectaddress=nas.simscop.com
:: netsh interface portproxy delete v4tov4 listenaddress=127.0.0.1 listenport=445

echo checking the port number...
netsh interface portproxy show all

echo delete the nas password...
cmdkey /delete 127.0.0.1 > nul

cls
echo.
echo ====================================================================
echo %yellow% NOTE: IF THE LAST NUMBER IS 4, PLEASE REBOOT COMPUTER %reset%
echo.
:: must stop the service -> Server and reboot computer
:: the services manager panel -> Win+R -> services.msc
netstat -aon | findstr "445"
pause
echo.
echo ====================================================================
echo.

set /p UserName=Input Your UserName: 
set /p Password=Input Your Password: 
cmdkey /add:127.0.0.1 /user:%UserName% /pass:%Password%

echo.
echo ====================================================================

echo waking up server, please wait ...
start "" "\\127.0.0.1"

:: remote the nas password 
:: cmdkey /list | findstr nas.simscop.com

pause