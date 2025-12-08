## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

## Keep ZEGO classes (for your video call plugins)
-keep class **.zego.**{*;}
-keep class **.**.zego_zpns.** { *; }

## General Android rules
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

## Suppress warnings for common classes
-dontwarn java.lang.invoke.StringConcatFactory