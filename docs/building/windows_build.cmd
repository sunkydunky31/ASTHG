@echo off
cls

title ASTHG Build State

rem ------------- CONFIG -----------------
set CWD="%UserProfile%/Documents/ASTHG/"
set PLATFORM="cpp"
set BUILD_FLAGS="-debug"
rem --------------------------------------

echo Current configuration:
echo CWD: %CWD%
echo Platform: %PLATFORM%
echo Build Flags: %BUILD_FLAGS%
echo .
pause
cls

cd %CWD%

echo Building...
lime test %PLATFORM% %BUILD_FLAGS%