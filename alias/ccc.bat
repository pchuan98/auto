@echo off

setlocal enabledelayedexpansion

set "args="
for %%a in (%*) do (
    set "arg=%%a"
    set "args=!args! '!arg!'"
)

set DISABLE_AUTOUPDATER=1
set DISABLE_TELEMETRY=1
set BASH_MAX_OUTPUT_LENGTH=500

set ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic
set ANTHROPIC_AUTH_TOKEN=
set ANTHROPIC_MODEL=glm-4.5
set ANTHROPIC_SMALL_FAST_MODEL=glm-4.5-air

where pwsh >nul 2>&1
if %errorlevel% neq 0 (
    echo PowerShell not installed, using cmd to run...
    claude %*
) else (
   pwsh -c "claude !args!"
)