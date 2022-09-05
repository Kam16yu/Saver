import 'package:flutter/material.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("List"),
        centerTitle: true,),
      body: Column(
        children: [
          const Text("Main Screen", style: TextStyle(color: Colors.white)),
          ElevatedButton(onPressed: () {
            // Go to the next page, the pages overlap
            //Navigator.pushNamedAndRemoveUntil(context, '/todo', (route) => false);
            //Navigator.pushNamed(context, '/todo');
            //Not overlap
            Navigator.pushReplacementNamed(context, '/todo');
          }, child: const Text("Next"))
          ],
      ),
    );
  }
}
