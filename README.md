# flutter stories editor
This is a package created in the style of the instagram story creator, with which you can create images with images, texts, stickers (Gifs), finger drawing. They can be exported as an image to the gallery or shared directly to social networks.

## Features
[✔️] Draggable image

[✔️] Draggable text

[✔️] Draggable Gif/Sticker (giphy API)

[✔️] Gradient container background

[✔️] Finger painting (normal/translucent/neon)

[✔️] Custom colors, gradients and font families

[✔️] Custom gallery picker (own package => [gallery_media_picker](https://pub.dev/packages/gallery_media_picker))

[✔️] Save draft as image

[✔️] Get draft local path uri

[✔️] Text animations => [animated_text_kit](https://pub.dev/packages/animated_text_kit)

[✔️] Save draft as a gif

## Future features


[❌] Color filters


## Demo
If you don't see the images go to the [github repository](https://github.com/camilo1498/stories_editor) and by the way give me a star :D

<p float="left"> 
   <img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/demo.gif" alt="showcase gif" title="custom view" width="200"/>
   <img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/text_animations.gif" alt="showcase gif" title="custom view" width="200"/> 
</p>

## Installation
*This package has been tested in Android and ios, some features works on flutter web*

Add `stories_editor: 0.1.8` to your `pubspec.yaml` dependencies and then import it.


```dart
import 'package:stories_editor/stories_editor.dart';
```
## Apk release build

This package uses Ffmpeg to render and create the corresponding video/gif, due to that the size of the application is almost three times larger than normal, to avoid this you must use the following command to split each file in its respective "abi".

`flutter build apk --split-per-abi`

This command results in three APK files:

`<app dir>/build/app/outputs/apk/release/app-armeabi-v7a-release.apk`

`<app dir>/build/app/outputs/apk/release/app-arm64-v8a-release.apk`

`<app dir>/build/app/outputs/apk/release/app-x86_64-release.apk`

## How to use
1)
   ### Android
   add uses-permission `AndroidMAnifest.xml` file
      ```xml
       <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
       <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
           android:maxSdkVersion="31" />
       <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
       <uses-permission android:name="android.permission.INTERNET" />
       <uses-permission android:name="android.permission.VIBRATE"/>
      ```

   ### ios
   add this config to your `config.plist`
      ```xml
      <key>NSPhotoLibraryUsageDescription</key>
      <string>Privacy - Photo Library Usage Description</string>
      <key>NSMotionUsageDescription</key>
      <string>Motion usage description</string>
      <key>NSPhotoLibraryAddUsageDescription</key>
      <string>NSPhotoLibraryAddUsageDescription</string>
      ```
2) Create a `StoriesEditor()` widget with the follow params:

```dart
StoriesEditor(
    onDone: (String uri){
      /// uri is the local path of final render Uint8List
      /// here your code
    },
    colorList: [] /// (List<Color>[]) optional param 
    gradientColors: [] /// (List<List<Color>>[]) optional param 
    middleBottomWidget: Container() /// (Widget) optional param, you can add your own logo or text in the bottom tool
    fontFamilyList: [] /// (List<String>) optional param
    isCustomFontList: '' /// (bool) if you use a own font list set value to "true"
    onDoneButtonStyle: Container() /// (Widget) optional param, you can create your own button style
    onBackPress: /// (Future<bool>) optional param, here you can add yor own style dialog
    editorBackgroundColor: /// (Color) optional param, you can define your own background editor color
    galleryThumbnailQuality: /// (int = 200) optional param, you can set the gallery thumbnail quality (higher is better but reduce the performance)
);
```

## Example
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stories_editor/stories_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter stories editor Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);



  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesEditor(
                onDone: (uri){
                  debugPrint(uri);
                  Share.shareFiles([uri]);
                },
              ))
              );
            },
            child: const Text('Open Stories Editor'),
          ),
        )
    );
  }
}

```

### Issues

1) Issue of photo_View: [photo_view#499](bluefireteam/photo_view#499)
   Issue log => *To safely refer to a widget's ancestor in its dispose() method, save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() in the widget's didChangeDependencies() method.*



## ScreenShots


initial view
<p float="left"> 
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/1.jpg" width="130" height="250">
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/2.jpg" width="130" height="250">
</p>  


Custom image picker made with [Photo_manager](https://pub.dev/packages/photo_manager) package
<p float="left"> 
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/3.jpg" width="130" height="250">
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/4.jpg" width="130" height="250">
</p>  


Gradient background taking image color pixel
<p float="left"> 
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/20.jpg" width="130" height="250">
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/21.jpg" width="130" height="250">
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/22.jpg" width="130" height="250">
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/23.jpg" width="130" height="250">
</p>  


Exit Dialog
<p float="left"> 
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/5.jpg" width="130" height="250">
</p>  


Custom Gif Picker made with a [fork](https://github.com/camilo1498/giphy_picker) of [Giphy_picker](https://pub.dev/packages/giphy_picker) package
<p float="left"> 
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/7.jpg" width="130" height="250">
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/8.jpg" width="130" height="250">
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/9.jpg" width="130" height="250">
</p>  


Custom finger Drawing made with [perfect_freehand](https://pub.dev/packages/perfect_freehand) package
<p float="left"> 
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/14.jpg" width="130" height="250">
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/24.jpg" width="130" height="250">
</p>  


Text Editor
<p float="left"> 
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/10.jpg" width="130" height="250">
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/11.jpg" width="130" height="250">
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/12.jpg" width="130" height="250">
</p>  


All features together
<p float="left"> 
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/17.jpg" width="130" height="250">
</p>  


Share to social networks made with [share_plus](https://pub.dev/packages/share_plus) package
<p float="left"> 
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/19.jpg" width="130" height="250">
</p>  


Saved image
<p float="left"> 
<img src="https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/18.jpg" width="130" height="250">
</p>  


              
