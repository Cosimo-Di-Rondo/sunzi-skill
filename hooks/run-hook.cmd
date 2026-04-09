@echo off
setlocal

set "HOOK_NAME=%~1"
set "SCRIPT_DIR=%~dp0"

where pwsh >nul 2>&1 && (
    pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%%HOOK_NAME%.ps1"
    exit /b %ERRORLEVEL%
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%%HOOK_NAME%.ps1"
exit /b %ERRORLEVEL%
