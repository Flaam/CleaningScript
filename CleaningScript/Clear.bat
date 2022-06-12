@echo off
color 9
title CleaningScript [https://cleaner.flaam.xyz]
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
:: Remove temporary files for known Temp folders
echo Clearing Temporary files...
echo Script will automatically close
del /s /f /q c:\windows\temp\*.* 2>nul >nul
del /s /f /q C:\WINDOWS\Prefetch 2>nul >nul
del /s /f /q %temp%\*.* 2>nul >nul
rd /s /q c:\windows\tempor~1 2>nul >nul
rd /s /q c:\windows\temp 2>nul >nul
rd /s /q c:\windows\tmp 2>nul >nul
rd /s /q c:\windows\ff*.tmp 2>nul >nul
rd /s /q c:\windows\history 2>nul >nul
rd /s /q c:\windows\cookies 2>nul >nul
rd /s /q c:\windows\recent 2>nul >nul
rd /s /q c:\windows\spool\printers 2>nul >nul
del /s /f /q %windir%\temp*.* 2>nul >nul
rd /s /q %windir%\temp 2>nul >nul
md %windir%\temp 2>nul >nul
del /s /f /q %windir%\Prefetch*.* 2>nul >nul
rd /s /q %windir%\Prefetch 2>nul >nul
md %windir%\Prefetch 2>nul >nul
del c:\WIN386.SWP 2>nul >nul
rd /s /q %temp% 2>nul >nul
del /s /f /q %temp%\*.* 2>nul >nul
:: DLLCache cleaning
del /s /f /q %windir%\system32\dllcache*.* 2>nul >nul
rd /s /q %windir%\system32\dllcache 2>nul >nul
md %windir%\system32\dllcache 2>nul >nul
del /s /f /q “%SystemDrive%\Temp”*.* 2>nul >nul
rd /s /q “%SystemDrive%\Temp” 2>nul >nul
md “%SystemDrive%\Temp” 2>nul >nul
del /s /f /q %temp%*.* 2>nul >nul
rd /s /q %temp% 2>nul >nul
md %temp% 2>nul >nul

