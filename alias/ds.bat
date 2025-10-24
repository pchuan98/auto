@echo off

setlocal enabledelayedexpansion

set Z_AI_MODE=ZHIPU
set Z_AI_API_KEY=0a470f3fe50f470f8568dc8966f1c73b.lZPuea0HrKXspSen

set "args="
for %%a in (%*) do (
    set "arg=%%a"
    set "args=!args! '!arg!'"
)

set http_proxy=http://127.0.0.1:1080
set https_proxy=http://127.0.0.1:1080

set CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
set CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL=1

set ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
set ANTHROPIC_AUTH_TOKEN=sk-41dfe23c5c2847e3b627ce4a9e04cae0
set API_TIMEOUT_MS=600000
set ANTHROPIC_MODEL=deepseek-chat
set ANTHROPIC_SMALL_FAST_MODEL=deepseek-chat
set CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

@REM Set MCP config as JSON string
set "MCP_CONFIG_JSON={\"mcpServers\": {\"web-search-prime\": {\"type\": \"http\", \"url\": \"https://open.bigmodel.cn/api/mcp/web_search_prime/mcp\", \"headers\": {\"Authorization\": \"0a470f3fe50f470f8568dc8966f1c73b.lZPuea0HrKXspSen\"}}, \"zai-mcp-server\": {\"type\": \"stdio\", \"command\": \"npx\", \"args\": [\"-y\", \"@z_ai/mcp-server\"]}}}"

@REM Set allowed tools (comma or space-separated)
set "ALLOWED_TOOLS=Bash,Read,Glob,Grep,WebFetch,WebSearch"

where pwsh >nul 2>&1
if %errorlevel% neq 0 (
    echo PowerShell not installed, using cmd to run...
    claude --mcp-config "%MCP_CONFIG_JSON%" --allowedTools "%ALLOWED_TOOLS%" %*
) else (
   pwsh -c "claude --mcp-config '!MCP_CONFIG_JSON!' --allowedTools '!ALLOWED_TOOLS!' !args!"
)