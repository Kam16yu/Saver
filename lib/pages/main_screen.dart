import 'package:flutter/material.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("List"),
        centerTitle: true,),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {
            // Go to the next page, the pages overlap
            //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            //Navigator.pushNamed(context, '/home');
            //Not overlap
            Navigator.pushReplacementNamed(context, '/home');
          }, child: const Text("Saved objects")),
          ElevatedButton(onPressed: () {
            // Go to the next page, the pages overlap
            //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            //Navigator.pushNamed(context, '/home');
            //Not overlap
            Navigator.pushReplacementNamed(context, '/camera');
          }, child: const Text("Take photo")),

        ],
      ),
    );
  }
}
