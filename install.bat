@echo off
REM Installation script for wtf on Windows

set WTF_DIR=%APPDATA%\wtf
if not exist "%WTF_DIR%" (
    mkdir "%WTF_DIR%"
    echo Created directory %WTF_DIR%
)

copy wtf_new.py "%WTF_DIR%\wtf.py"

(
  echo @echo off
  echo python "%~dp0\wtf.py" %*
) > "%WTF_DIR%\wtf.bat"

(
  echo python "$PSScriptRoot\wtf.py" $args
) > "%WTF_DIR%\wtf.ps1"

setx PATH "%PATH%;%WTF_DIR%"

echo.
echo wtf has been installed.
echo 'wtf.bat' and 'wtf.ps1' have been created in %WTF_DIR%
echo For PowerShell users, 'wtf.ps1' is recommended.
echo Please restart your terminal for the changes to take effect.
echo You can then run 'wtf --init' to get started.
