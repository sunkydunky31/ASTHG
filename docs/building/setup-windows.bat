@echo off
color 0a
cd ..
echo Installing dependencies.
echo This might take a few moments depending on your internet speed.
haxelib install lime 8.1.2
haxelib install openfl
haxelib install flixel 5.6.1
haxelib install flixel-addons 3.2.2
haxelib install flixel-tools 1.5.1
haxelib install tjson
haxelib run lime setup
haxelib git hxdiscord_rpc https://github.com/FunkinCrew/hxdiscord_rpc 82c47ecc1a454b7dd644e4fcac7e91155f176dec
echo Finished!
pause
