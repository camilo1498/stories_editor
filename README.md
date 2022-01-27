

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Installation

Add `stories_editor: 0.1.0` yo your `pubspec.yaml` dependencies and then import it.

```dart
import 'package:stories_editor/stories_editor.dart';
```

## How to use

1) add `MultiProvider` in your `runApp()` as bellow:
```dart
void main() {
  runApp(
    MultiProvider(
      providers: StoriesEditorProvider().providers, /// is required to use it
      child: const MyApp(),
    )
  );
}
```
2) Create a `StoriesEditor()` widget, and pass the params:

```dart
StoriesEditor(
    giphyKey: '[YOUR GIPHY API KEY]', /// (String) required param
     onDone: (String uri){
      /// uri is the local path of final render Uint8List
      /// here your code
     },
    colorList: [] /// (List<Color>[]) optional param 
    gradientColors: [] /// (List<List<Color>>[]) optional param 
    middleBottomWidget: Container() /// (Widget) optional param, you can add your own logo or text in the bottom tool
    fontList: [] /// (List<String>) optional param
    fontPackage: '' /// (String) if you use a own font list is required add your name app package
);
```

## Example
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stories_editor/stories_editor.dart';

void main() {
  runApp(
    MultiProvider(
      providers: StoriesEditorProvider().providers,
      child: const MyApp(),
    )
  );
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
        body: Container(
          child: Center(
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesEditor(
                  giphyKey: '[YOUR GIPHY API KEY]',
                  onDone: (uri){
                    print(uri);
                    if(uri != null){
                      Share.shareFiles([uri]);
                    }
                  },
                ))
                );
              },
              child: const Text('Open Stories Editor'),
            ),
          ),
        )
    );
  }
}

```

## ScreenShots


![Demo Gif video](https://github.com/camilo1498/stories_editor/blob/main/stories%20editor%20screenshots/demo.gif)


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


## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
