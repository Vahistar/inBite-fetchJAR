@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

call :print_logo

set "URL="
set /p "URL=Enter the URL to fetch: "

if not defined URL (
    echo No URL provided.
    exit /b 1
)

if exist build rmdir /s /q build
mkdir build\classes

> "build\config.properties" echo url=!URL!

javac -encoding UTF-8 -d build\classes src\Main.java
if errorlevel 1 exit /b 1

copy /y build\config.properties build\classes\config.properties >nul

jar --create --file server.jar --main-class Main -C build\classes .

echo.
echo Built server.jar
exit /b 0

:print_logo
if not exist "logo.txt" exit /b 0
powershell -NoProfile -ExecutionPolicy Bypass -Command "$q=[char]34;$d='[DllImport('+$q+'kernel32.dll'+$q+')]public static extern IntPtr GetStdHandle(int n);[DllImport('+$q+'kernel32.dll'+$q+')]public static extern bool GetConsoleMode(IntPtr h,ref uint m);[DllImport('+$q+'kernel32.dll'+$q+')]public static extern bool SetConsoleMode(IntPtr h,uint m);';try{Add-Type -Namespace K -Name W -MemberDefinition $d -ErrorAction Stop;$h=[K.W]::GetStdHandle(-11);$m=[uint32]0;if([K.W]::GetConsoleMode($h,[ref]$m)){[void][K.W]::SetConsoleMode($h,$m -bor 4)}}catch{};[Console]::Out.Write([IO.File]::ReadAllText('logo.txt',[Text.Encoding]::UTF8))"
exit /b 0
