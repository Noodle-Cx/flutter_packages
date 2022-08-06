import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noodle_camera/noodle_camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noodle camera',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Noodle camera'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showCameraWidget = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Single Picture'),
              onPressed: () async {
                final List<File>? images = await NoodleCameraPicturePage.show(
                  context: context,
                  title: 'Single Picture',
                );
                if (images != null) {
                  //here you can get your image file with images[0]
                }
              },
            ),
            ElevatedButton(
              child: const Text('Multiple pictures'),
              onPressed: () async {
                final List<File>? images = await NoodleCameraPicturePage.show(
                  context: context,
                  title: 'Multiple pictures',
                  multiPictures: true,
                );
                if (images != null) {
                  //here you can get your images file here
                }
              },
            ),
            ElevatedButton(
              child: const Text('Scan Qr Code'),
              onPressed: () async {
                final readData = await NoodleCameraScanPage.show(
                  context: context,
                  title: 'Scan Qr Code',
                  cameraMask: CameraMask.qrCode(
                    button: TextButton(
                      child: const Text('Type Qr Code'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  validator: (data) {
                    // check if read data value is valid to camera stop scanner and returns this value
                    return true;
                  },
                );

                if (readData != null) {
                  // you can get the result of scan here
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(readData),
                  ));
                }
              },
            ),
            ElevatedButton(
              child: const Text('Scan barcode'),
              onPressed: () {
                try {
                  NoodleCameraScanPage.show(
                    context: context,
                    title: 'Scan barcode',
                    deviceOrientation: DeviceOrientation.landscapeLeft,
                    validator: (data) {
                      // check if read data value is valid to camera stop scanner and returns this value
                      return true;
                    },
                    cameraMask: CameraMask.barcode(
                      button: TextButton(
                        child: const Text('Type barcode'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                } catch (e, s) {
                  print(s);
                }
              },
            ),
            ElevatedButton(
              child: Text(
                  showCameraWidget ? 'Hide camera view' : 'Show camera View'),
              onPressed: () {
                setState(() {
                  showCameraWidget = !showCameraWidget;
                });
              },
            ),
            Visibility(
              visible: showCameraWidget,
              child: const SizedBox(
                width: 500,
                height: 500,
                child: NoodleCameraView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
