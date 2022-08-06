# Noodle Camera

## What is Noodle camera?
Noodle camera is a all in one Widget camera, the widget provides a interface to take pictures, or scan codes in a simple way.

## Examples

### Take single picture 
```dart
  ElevatedButton(
    child: const Text('Single Picture'),
    onPressed: () async {
      final List<File>? images = await  NoodleCameraPicturePage.show(context: context, title: 'Single Picture');
      if(images != null) {
        //here you can get your image file with images[0]
      }
    },
  ),
```

### Take multiple pictures
```dart
  ElevatedButton(
    child: const Text('Multiple pictures'),
    onPressed: () async {
      final List<File>? images = await  NoodleCameraPicturePage.show(
        context: context, 
        title: 'Multiple pictures',
        multiPictures: true,
      );
      if(images != null) {
        //here you can get your image file with images[0]
      }
    },
  ),
```

### Scan a qrCode or Barcode
```dart
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
```



## Request updates
- To request updates or fixes, please open a pull request on Github.
