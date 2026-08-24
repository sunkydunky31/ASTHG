#!/bin/bash

haxelib run hmm install

# Remove unnecessary packages
haxelib remove flixel 6.2.0
haxelib remove hxcpp 4.3.2
haxelib remove thx.core 0.44.0

# Setup build environment
haxelib run lime setup linux
