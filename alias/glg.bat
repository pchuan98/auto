@echo off

setlocal enabledelayedexpansion

set "args="
for %%a in (%*) do (
    set "arg=%%a"
    set "args=!args! '!arg!'"
)

where pwsh >nul 2>&1
if %errorlevel% neq 0 (
    echo PowerShell not installed, using cmd to run...
    if "%~1"=="" (
        git log --oneline --all --graph -10
    ) else (
        git log --oneline --all --graph %*
    )
) else (
    if "!args!"=="" (
        pwsh -c "git log --oneline --all --graph -10"
    ) else (
        pwsh -c "git log --oneline --all --graph !args!"
    )
)