@echo off
REM Uninstallation script for wtf on Windows

REM Remove the application directory
set WTF_DIR=%APPDATA%\wtf
if exist "%WTF_DIR%" (
    rmdir /s /q "%WTF_DIR%"
    echo Removed directory %WTF_DIR%
)

echo.
echo wtf has been uninstalled.
echo Please manually remove '%%APPDATA%%\wtf' from your PATH environment variable.
echo You may need to restart your terminal for the changes to take effect.
