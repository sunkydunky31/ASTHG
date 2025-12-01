# List of sizes for Android

If you're looking for edit the drawables or set mipmaps, go to [this path](../../_project/templates/android/template/app/src/main/res/)

## For VectorDrawable:

 - Set viewport to a highest value; 
 - Insert `<group>` define with `android:translateX=""` and `android:translateY=""` properties;
 - Change the values to your preference;
 - And there you go! you don't needed to resize your VectorDrawable icon.   
                    Make sure to check on Android Studio how it will look..

## For `mipmaps`

Remember to define a blank space on your icon or it will be zoomed!

|Directory            |Size   |
|:-------------------:|:-----:|
|drawable-hdpi        |72x72  |
|drawable-ldpi        |36x36  |
|drawable-mdpi        |48x48  |
|drawable-xhdpi       |96x96  |
|drawable-xhdpi (OUYA)|732x412|
|drawable-xxhdpi      |144x144|
|drawable-xxxhdpi     |192x192|