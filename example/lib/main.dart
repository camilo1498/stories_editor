import 'package:flutter/material.dart';
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
  int colorIndex = 0;
  List<Color> colors = [
    Colors.black,
    Colors.blue,
    Colors.red,
    Colors.yellowAccent,
    Colors.tealAccent,
    Colors.pink,
    Colors.lightGreen,
    Colors.indigo,
    Colors.amber,
    Colors.orange,
    Colors.lime,
    Colors.purple,
    Colors.grey,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.green,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text('Background color',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ...colors.map((color) {
                        return _colorPalette(
                            color: color,
                            onTap: () {
                              setState(() {
                                colorIndex = colors.indexOf(color);
                              });
                            });
                      })
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoriesEditor(
                            giphyKey: '[HERE YOU GIPHY API KEY]',
                            //fontFamilyList: const ['Shizuru', 'Aladin'],
                            galleryThumbnailQuality: 300,
                            editorBackgroundColor: colors[colorIndex],
                            //isCustomFontList: true,
                            onDone: (uri) {
                              debugPrint(uri);
                              Share.shareFiles([uri]);
                            },
                          )));
                },
                child: const Text('Open Stories Editor'),
              ),
            ],
          ),
        ));
  }

  Widget _colorPalette({required Function() onTap, required Color color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            height: 40,
            width: 40,
            child: Center(
              child: color == colors[colorIndex] ? const Icon(
                Icons.check,
                size: 20,
                color: Colors.white,
              ) : Container(),
            ),
          ),
        ),
      ),
    );
  }

}
