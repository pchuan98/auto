@echo off

setlocal enabledelayedexpansion

set "args="
for %%a in (%*) do (
    set "arg=%%a"
    set "args=!args! '!arg!'"
)

set http_proxy=http://127.0.0.1:1080
set https_proxy=http://127.0.0.1:1080

rem 检查 claude 是否已安装
where claude >nul 2>&1
if %errorlevel% neq 0 (
    echo Claude CLI not installed, installing...
    npm install -g @anthropic-ai/claude-code
    if %errorlevel% neq 0 (
        echo Claude CLI installation failed
        exit /b 1
    )
    echo Claude CLI installation completed
)

set DISABLE_AUTOUPDATER=1
set DISABLE_TELEMETRY=1
set BASH_MAX_OUTPUT_LENGTH=500

set ANTHROPIC_BASE_URL=
set ANTHROPIC_AUTH_TOKEN=
set ANTHROPIC_MODEL=
set ANTHROPIC_SMALL_FAST_MODEL=

where pwsh >nul 2>&1
if %errorlevel% neq 0 (
    echo PowerShell not installed, using cmd to run...
    claude %*
) else (
   pwsh -c "claude !args!"
)