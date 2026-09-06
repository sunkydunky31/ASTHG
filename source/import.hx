#if !macro
import asthe.backend.ClientPrefs;
import asthe.backend.Constants;
import asthe.backend.CoolUtil;
#if DISCORD_ALLOWED import asthe.backend.DiscordClient; #end
import asthe.backend.Locale;
#if MODS_ALLOWED import asthe.backend.Mods; #end
import asthe.backend.Paths;
import asthe.backend.StateManager;
import asthe.backend.SubStateManager;
import asthe.input.Controls;
import asthe.states.LoadingState;
import asthe.framework.*;
import asthe.util.*;
import util.*;
using util.StringUtil;
using asthe.util.Ansi;

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