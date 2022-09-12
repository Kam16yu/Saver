import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:list_of_importants/database/dbhelper.dart';
import '../database/model.dart';


class CreateCard extends StatefulWidget {
  const CreateCard({Key? key}) : super(key: key);
  @override
  State<CreateCard> createState() => _CreateCardState();
}
class _CreateCardState extends State<CreateCard> {
  var id = 1;
  var cardName = 'New Card';
  var cardText = 'Empty';
  var pict = Uint8List(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      //AppBar, Save button
      appBar: AppBar(
        title: const Text("New Card"),
        centerTitle: true,
        actions: [
          TextButton(
            style:  TextButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () {
                // Go to the next page, the pages overlap
                //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                // Navigator.pushNamed(context, '/home'); //Not overlap
                print("saved " + cardName + " " + cardText);

                DbCard card = DbCard(id: id, name: cardName,text: cardText,
                    pict: pict,time: DateTime.now().toString());

                Dbhelper db = Dbhelper();
                db.insertCard(card).then((value) =>
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false));
                db.getCards().then((value) => print(value));
                },
              child: const Text("Save"),)
        ],
      ),

      // 2 Textfields
      body:  Column(
        children: [
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'Card Name'),
          onChanged:  (val) => cardName = val,
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              maxLines: null,
              minLines: null,
              decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter text',),
              onChanged:(val) => cardText = val,
            ),
          ),
        ]),

      // Bottom bar, MIC, CAMERA, PICTURE?
      bottomNavigationBar: BottomAppBar(
        color: Colors.white38,
        elevation: 10,
        child: Row (
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              padding: const EdgeInsets.fromLTRB(8.0,8.0,20.0,8.0),
              icon: const Icon(Icons.mic),
              onPressed: () {Navigator.pushNamed(context, '/');},
              iconSize: 40.0,),
            IconButton(
              padding: const EdgeInsets.fromLTRB(8.0,8.0,20.0,8.0),
              icon: const Icon(Icons.image),
              onPressed: () {},
              iconSize: 40.0,
            ),
            IconButton(
                // Go to the next page, the pages overlap
              icon: const Icon(Icons.camera),
              onPressed: () {Navigator.pushNamed(context, '/camera');},
              iconSize: 40.0,
              ),
        ]),
      ),
    );
  }
}

