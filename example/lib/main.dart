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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoriesEditor(
                            giphyKey: '[HERE YOUR API KEY]',
                            fontFamilyList: const ['Shizuru', 'Aladin'],
                            isCustomFontList: true,
                            onDone: (uri) {
                              debugPrint(uri);
                              Share.shareFiles([uri]);
                            },
                            // onDoneButtonStyle: Center(child: Text('example', style: TextStyle(color: Colors.white),)), /// restart application to see changes
                            //onBackPress: _popScope(), /// here you can add yor own style dialog
                          )));
            },
            child: const Text('Open Stories Editor'),
          ),
        ));
  }

  // Future<bool> _popScope() async {
  //   return true; /// use dialog
  // }
}
