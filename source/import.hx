#if !macro

import asthg.framework.*;

import asthg.backend.ClientPrefs;
import asthg.backend.Constants;
import asthg.backend.CoolUtil;
#if DISCORD_ALLOWED
import asthg.backend.Discord;
#end
import asthg.backend.Locale;
#if MODS_ALLOWED
import asthg.backend.Mods;
#end
import asthg.backend.Paths;
import asthg.backend.StateManager;
import asthg.backend.SubStateManager;
import asthg.input.Controls;
import asthg.states.LoadingState;
import asthg.util.*;
import util.*;
using util.StringUtil;
using asthg.util.Ansi;

//---------------------------------//

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;

using StringTools;
#end