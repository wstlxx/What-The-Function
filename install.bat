@echo off
setlocal enabledelayedexpansion

echo Checking for dependencies...

REM Check for Python
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Warning: Python is not installed or not in your PATH.
    echo Please install Python to use this tool: https://www.python.org/downloads/
    set /p "choice=Do you want to continue the installation anyway? (y/n): "
    if /i "!choice!" neq "y" (
        echo Installation aborted.
        exit /b 1
    )
) else (
    echo Python found.
)

REM Check for pip
where pip >nul 2>nul
if %errorlevel% neq 0 (
    echo Warning: pip is not installed or not in your PATH.
    echo pip is required to install Python packages.
    set /p "choice=Do you want to continue the installation anyway? (y/n): "
    if /i "!choice!" neq "y" (
        echo Installation aborted.
        exit /b 1
    )
) else (
    echo pip found.
    echo Installing 'requests' package...
    python -m pip install requests
    if %errorlevel% neq 0 (
        echo Warning: Failed to install 'requests' package. Please try again.
    ) else (
        echo 'requests' package installed successfully.
    )
)


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
