# List of sizes for Android

If you're looking for edit the app resources, go to [this path](../../_project/templates/android/template/app/src/main/res/)

## For VectorDrawable:

 - Set image to `108dp`;
 - Set viewport to `108.0`;
 - Create a new `<group>` into your whole graphic and set these parameters:
    - `android:translateX`, `android:translateY`: 18 (safe mask, set 21 to use ultra safe mask)
    - `android:scaleX`, `android:scaleY`: 2.5 (Default icon uses that value, change it if you want)
 And there you go! you don't needed to resize your VectorDrawable icon.    
 Make sure to check on Android Studio how it will look..

## For `mipmaps`

### Adaptive icons (Android 8.0+)

 - Your icon must have at minimun 108px;
 - Your icon needs to be 18px to the left and 18px below (multiply this space to the scale of the icon), otherwise your icon will be cut off by the Android Launcher icon mask. (To help you, this guide have "icon masks" to make the process of creating your icon easier)

### Legacy (Android 7.0-)
|Directory            |Size   |
|:-------------------:|:-----:|
|drawable-hdpi        |72x72  |
|drawable-ldpi        |36x36  |
|drawable-mdpi        |48x48  |
|drawable-xhdpi       |96x96  |
|drawable-xhdpi (OUYA)|732x412|
|drawable-xxhdpi      |144x144|
|drawable-xxxhdpi     |192x192|