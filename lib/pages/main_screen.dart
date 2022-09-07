import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("New Card"),
        centerTitle: true,
        actions: [
          TextButton(
            style:  TextButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 15),
              ),
            onPressed: () {
            // Go to the next page, the pages overlap
            //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            //Navigator.pushNamed(context, '/home');
           //Not overlap
            Navigator.pushNamed(context, '/home');},
              child: const Text("Saved cards"),)
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(children:[])
            ]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white38,
        elevation: 10,
        child: Row (
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              padding: const EdgeInsets.fromLTRB(8.0,8.0,20.0,8.0),
              icon: Icon(Icons.mic),
              onPressed: () {Navigator.pushNamed(context, '/');},
              iconSize: 40.0,),
            IconButton(
              padding: const EdgeInsets.fromLTRB(8.0,8.0,20.0,8.0),
              icon: Icon(Icons.create),
              onPressed: () {Navigator.pushNamed(context, '/home');},
              iconSize: 40.0,),
            IconButton(
                // Go to the next page, the pages overlap
                //Navigator.pushNamedAndRemoveUntil(context, '/camera', (route) => false);
                // Navigator.pushReplacementNamed(context, '/camera');
                //Navigator.pushNamed(context, '/camera'), //Not overlap
              icon: Icon(Icons.camera),
              onPressed: () {Navigator.pushNamed(context, '/camera');},
              iconSize: 40.0,
              ),

        ]),
      ),
      );
  }
}

