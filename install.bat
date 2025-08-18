@echo off
setlocal enabledelayedexpansion

REM Installation script for wtf on Windows

set WTF_DIR=%APPDATA%\wtf
if not exist "%WTF_DIR%" (
    mkdir "%WTF_DIR%"
    echo Created directory %WTF_DIR%
)

copy wtf_new.py "%WTF_DIR%\wtf.py" > nul

(
  echo @echo off
  echo python "%~dp0\wtf.py" %*
) > "%WTF_DIR%\wtf.bat"

(
  echo python "$PSScriptRoot\wtf.py" $args
) > "%WTF_DIR%\wtf.ps1"


echo Adding %WTF_DIR% to the user PATH.

set REG_KEY="HKEY_CURRENT_USER\Environment"
set REG_VALUE="PATH"

REM Get the current PATH value
for /f "tokens=2*" %%a in ('reg query %REG_KEY% /v %REG_VALUE% 2^>nul') do (
    set CurrentPath=%%b
)

REM Check if the path is already there
echo ";!CurrentPath!;" | find /I ";%WTF_DIR%;" >nul
if %errorlevel%==0 (
    echo %WTF_DIR% is already in your PATH.
) else (
    echo Appending %WTF_DIR% to your PATH.
    REM If CurrentPath is empty, we set it. Otherwise, we append.
    if defined CurrentPath (
        set "NewPath=!CurrentPath!;%WTF_DIR%"
    ) else (
        set "NewPath=%WTF_DIR%"
    )
    reg add %REG_KEY% /v %REG_VALUE% /t REG_EXPAND_SZ /d "!NewPath!" /f > nul
    if !errorlevel! == 0 (
        echo Successfully added %WTF_DIR% to your PATH.
    ) else (
        echo Failed to add %WTF_DIR% to your PATH. Please do it manually.
    )
)


echo.
echo wtf has been installed.
echo 'wtf.bat' and 'wtf.ps1' have been created in %WTF_DIR%
echo For PowerShell users, 'wtf.ps1' is recommended.
echo Please restart your terminal for the changes to take effect.
echo You can then run 'wtf --init' to get started.

endlocal
