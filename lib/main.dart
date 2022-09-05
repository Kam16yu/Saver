import 'package:flutter/material.dart';
import 'package:list_of_importants/pages/home.dart';
import 'package:list_of_importants/pages/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// App List of items, add/delete, 2 screens, used Firebase.

void initfirebase () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void main() {
  initfirebase ();
  runApp( MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.cyan,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => MainScreen(),
      '/todo': (context) => Home(),
    },
  ));
}