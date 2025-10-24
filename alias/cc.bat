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

set CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
set CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL=1
set MAX_THINKING_TOKENS=10000

set "ALLOWED_TOOLS=Bash,Read,Glob,Grep,WebFetch,WebSearch"

where pwsh >nul 2>&1
if %errorlevel% neq 0 (
    echo PowerShell not installed, using cmd to run...
    claude --allowedTools "%ALLOWED_TOOLS%" %*
) else (
   pwsh -c "claude --allowedTools '!ALLOWED_TOOLS!' !args!"
)