@echo off
REM Installation script for wtf on Windows

REM Create a directory for the application
set WTF_DIR=%APPDATA%\wtf
if not exist "%WTF_DIR%" (
    mkdir "%WTF_DIR%"
    echo Created directory %WTF_DIR%
)

REM Copy the Python script
copy wtf_new.py "%WTF_DIR%\wtf.py"

REM Create a batch file to run the Python script
echo @python "%WTF_DIR%\wtf.py" %* > "%WTF_DIR%\wtf.bat"

REM Add the directory to the user's PATH
setx PATH "%PATH%;%WTF_DIR%"

echo.
echo wtf has been installed.
echo Please restart your terminal for the changes to take effect.
echo You can then run 'wtf --init' to get started.
