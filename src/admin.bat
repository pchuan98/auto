@echo off
@REM %1 %2
@REM ver|find "5.">nul 
@REM mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof

@REM cd /d "%~dp0"

@REM SETLOCAL EnableDelayedExpansion
@REM for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
@REM   set "DEL=%%a"
@REM )
@REM echo ok
@REM pause

:: 获取管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" && (
    echo Permission already elevated
) || (
    echo Elevating permissions...
    powershell Start-Process "%0" -Verb RunAs
    pause
    exit /b
)

:: 继续执行需要管理员权限的操作
echo Running with elevated privileges.
:: ... 接下来的操作 ...

pause