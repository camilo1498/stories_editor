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
