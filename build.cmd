@echo off
cls

:: CONFIG
set CWD="%UserProfile%/Documents/default/"
set PLATFORM="cpp"
set BUILD_FLAGS="-debug"

cd %CWD%

echo Building...
lime test %PLATFORM% %BUILD_FLAGS%