import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../database/model.dart';
late XFile foto;

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key,required this.camera});
  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera, create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbcard = ModalRoute.of(context)!.settings.arguments as DbCard;
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // Waiting controller initialization before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      body:  FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
        ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            // Attempt to take a picture and get the file `image`
            // where it was saved.
            foto = await _controller.takePicture();
            if (!mounted) return;
            dbcard.pict = await foto.readAsBytes();
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: foto.path,
                  chcard: dbcard,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            e;
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final DbCard chcard;
  const DisplayPictureScreen({super.key, required this.imagePath,
    required this.chcard });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
     floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: ()  {
          Navigator.pushNamedAndRemoveUntil(context, '/CreateCardScreen',
                  (route) => false, arguments: chcard);
        }, child: const Text("Save")),
    );
  }
}
