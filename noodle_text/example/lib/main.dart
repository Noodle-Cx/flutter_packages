import 'package:flutter/material.dart';
import 'package:noodle_text/noodle_text.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Normal material App
    return MaterialApp(
      title: 'Noodle Text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Noodle Text'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NoodleText(
              'Example of <b>bold text</b>',
              style: const TextStyle(fontSize: 24),
            ),
            NoodleText(
              'Example of <i>italic text</i>',
              style: const TextStyle(fontSize: 24),
            ),
            NoodleText(
              'Example of <u>underline text</u>',
              style: const TextStyle(fontSize: 24),
            ),
            NoodleText(
              'Example of <c>color</c> <c>text</c>',
              style: const TextStyle(fontSize: 24),
              spanColors: const [Colors.blue, Colors.red],
            ),
            NoodleText(
              'Example <b><c>of</c></b> <i>multiple</i> <c><u>styles</u></c>',
              style: const TextStyle(fontSize: 24),
              spanColors: const [Colors.blue, Colors.red],
            ),
          ],
        ),
      ),
    );
  }
}
