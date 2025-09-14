#if !macro
#if DISCORD_ALLOWED
import backend.Discord;
#end

#if MODS_ALLOWED
import backend.Mods;
#end

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

import backend.ClientPrefs;
import backend.Controls;
import backend.Constants;
import backend.CoolUtil;
import backend.Language;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.Paths;

#if MODS_ALLOWED
import modding.Scripts;
#end

import states.LoadingState;
//---------------------------------//
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;

import sys.io.File;
import sys.FileSystem;

using StringTools;
#end