import 'package:flutter/material.dart';
import 'package:noodle_image/noodle_image.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Normal material App
    return MaterialApp(
      title: 'Noodle Image',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Noodle Image'),
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
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: const [
            SizedBox(
              height: 50,
            ),
            Text(
              'Local PNG asset:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            NoodleImage(
              'assets/images/flutter.png',
              height: 50,
              width: 50,
            ),
            SizedBox(height: 50),
            Text(
              'Local SVG asset:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            NoodleImage(
              'assets/images/flutter.svg',
              height: 50,
              width: 50,
            ),
            SizedBox(height: 50),
            Text(
              'Network png:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            NoodleImage(
              'https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png',
              height: 50,
              width: 50,
            ),
            SizedBox(height: 50),
            Text(
              'Network svg',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            NoodleImage(
              'https://www.svgrepo.com/show/353751/flutter.svg',
              height: 50,
              width: 50,
            ),
            SizedBox(height: 50),
            Text(
              'Base64 Image',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            NoodleImage(
              'data:image/png;base64,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',
              height: 50,
              width: 50,
            ),
          ],
        ),
      ),
    );
  }
}
