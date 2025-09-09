@echo off
setlocal

set http_proxy=http://127.0.0.1:1080
set https_proxy=http://127.0.0.1:1080

set ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic

set ANTHROPIC_MODEL=glm-4.5
set ANTHROPIC_SMALL_FAST_MODEL=glm-4.5-air

claude --verbose %*

endlocal