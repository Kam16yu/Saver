import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../database/dbhelper.dart';
import '../database/model.dart';
import 'package:image_picker/image_picker.dart';

class CreateCardScreen extends StatefulWidget {
  const CreateCardScreen({Key? key}) : super(key: key);

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}
class _CreateCardScreenState extends State<CreateCardScreen> {
  var id = 0;
  var cardName = '';
  var cardText = '';
  var pict = Uint8List(1);
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final dbcard = ModalRoute.of(context)?.settings.arguments as DbCard?;
    if (dbcard != null){
      id =  dbcard.id;
      cardName = dbcard.name;
      cardText = dbcard.text;
      pict = dbcard.pict;
    } else {
      Dbhelper db = Dbhelper();
      //get max ID in DB,then create Card object
      db.maxId().then((value) {
        id = value + 1;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      //AppBar, Save button
      appBar: AppBar(
        title: const Text("Card"),
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
                Dbhelper db = Dbhelper();
                //get max ID in DB,then create Card object
                DbCard card = DbCard(id: id,
                      name: cardName,
                      text: cardText,
                      pict: pict,
                      time: DateTime.now().toString().substring(0,19));
                // push Card in DB, then go to Home page
                db.insertCard(card).then((_) =>
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false));
                },
              child: const Text("Save"),)
        ],
      ),

      // 2 Textfields, 1 image
      body: Column(
        children: [
        TextFormField(
          initialValue: cardName,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'Card Name'),
          onChanged:  (val) => cardName = val,
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              initialValue: cardText,
              maxLines: null,
              minLines: null,
              decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter text',),
              onChanged:(val) => cardText = val,
            ),
          ),
          Expanded(
           child:
          Image.memory(pict,
            fit: BoxFit.fitWidth,
            errorBuilder:  (BuildContext context,
                Object exception, StackTrace? stackTrace) {
              return const Text("");}, //Error Builder
          ),)
        ]),

      // Bottom bar, MIC?, CAMERA, PICTURE?, DELETE?
      bottomNavigationBar: BottomAppBar(
        color: Colors.white38,
        elevation: 10,
        child: Row (
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              padding: const EdgeInsets.fromLTRB(8.0,8.0,20.0,8.0),
              icon: const Icon(Icons.delete),
              onPressed: () {
                var dbHelper = Dbhelper();
                dbHelper.deleteCard(id);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
              iconSize: 40.0,),
            IconButton(
              padding: const EdgeInsets.fromLTRB(8.0,8.0,20.0,8.0),
              icon: const Icon(Icons.mic),
              onPressed: () {},
              iconSize: 40.0,),
            IconButton(
              padding: const EdgeInsets.fromLTRB(8.0,8.0,20.0,8.0),
              icon: const Icon(Icons.image),
              onPressed: () async {
                XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                image?.readAsBytes().then((value) {
                  setState(() {pict = value;});
                });
              },
              iconSize: 40.0,
            ),
            IconButton(
                // Go to the next page, the pages overlap
              icon: const Icon(Icons.camera),
              onPressed: () {
                DbCard tempCard = DbCard(id: id,
                    name: cardName,
                    text: cardText,
                    pict: pict,
                    time: DateTime.now().toString().substring(0,19));
                Navigator.pushNamed(context, '/TakePictureScreen',
                arguments: tempCard);
                },
              iconSize: 40.0,
              ),
        ]),
      ),
    );
  }
}

