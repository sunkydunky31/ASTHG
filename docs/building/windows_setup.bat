@echo off
color 0a
cd ..
choice /m "Do you have Git installed?"
if %errorlevel%==0 (
    echo Install Git before using this!
    exit
)
echo Installing dependencies.
echo This might take a few moments depending on your internet speed.
REM If something breaks here, I'll change here
haxelib install lime 8.1.2
haxelib install openfl

REM Minimun recommended: 5.5.0
haxelib install flixel 5.9.0

haxelib install flixel-addons 3.2.2
haxelib install flixel-tools 1.5.1
haxelib install tjson
haxelib run lime setup

echo Getting HXDiscord RPC from Git
haxelib git hxdiscord_rpc https://github.com/FunkinCrew/hxdiscord_rpc 82c47ecc1a454b7dd644e4fcac7e91155f176dec
echo Finished!
pause
