import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:saver/pages/home.dart';
import 'package:saver/pages/create_card.dart';
import 'package:saver/pages/usecamera.dart';
// App List of items, add/delete, 2 screens, SQLite.


Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.cyan,),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(camera: firstCamera),
      '/CreateCardScreen': (context) => CreateCardScreen(),
      '/TakePictureScreen': (context) =>  TakePictureScreen(camera: firstCamera)
    },
  ));
}
