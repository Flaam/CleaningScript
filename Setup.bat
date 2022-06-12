@echo off
color 9
title CleaningScript - Setup [https://cleaner.flaam.xyz]
:: Administrator privileges checker
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:-------------------------------------- 
:: Setup of computername variable for schtasks
FOR /F "tokens=* USEBACKQ" %%F IN (`whoami`) DO (
SET computername=%%F
)
:: Task setup
echo The script will now ask for current user password to import the automatic task
echo If you login without a password and you are still getting a prompt, just click ENTER.
timeout 8
cls
schtasks /create /xml "CleaningScript/Task.xml" /tn "CleaningScript" /ru "%computername%"
cls
:: Move to C: disk
move "CleaningScript" C:\ 2>nul >nul
cls
:: Disclaimer
echo Scheduled Task was created and Script files were moved to C:\ disk 
echo If you delete the folder from C:\ the script will stop working. 
echo You can now close this window.
echo.
echo Download the script at: https://cleaner.flaam.xyz
echo.
echo DM on Twitter @FlaamFPS to report bugs.
pause