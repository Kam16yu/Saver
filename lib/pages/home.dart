import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todolist = [];
  String userTodo = '';

  void _menuOpen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: const Text("Menu"),),
            body: Row(
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, '/',
                          (route) => false);
                },child: const Text("To main page")
                ),
//RandomWords(),
              ],
            ),
          );
        })
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("List"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _menuOpen, icon: const Icon(Icons.menu_outlined))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("items").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Text("No Data");
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(snapshot.data!.docs[index].id), //get id key
                child: Card(
                  // get elem text from firebase
                  child: ListTile(title: Text(snapshot.data!.docs[index].get("item")),
                      //icon delete elem
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          //setState(() {todolist.removeAt(index);}); // delete elem
                          FirebaseFirestore.instance.collection("items").
                          doc(snapshot.data?.docs[index].id).delete();
                        },
                      )
                  ),
                ),
                onDismissed: (directional) {
                  //if (directional == DismissDirection.endToStart) swap direction check
                  //setState(() {todolist.removeAt(index);}); // delete elem
                  FirebaseFirestore.instance.collection("items").
                  doc(snapshot.data?.docs[index].id).delete();
                },
              );
            },
          );
        },
      ),



        // Add element button
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            // raise AlertDialog adding element
            return AlertDialog(
                title: const Text("Add element"),
                content: TextField(
                  onChanged: (String value) {
                    userTodo = value;
                  }, //onChanged
                ),
                actions: [
                  ElevatedButton(onPressed: (){
                    //State add element
                    //setState(() {todolist.add(userTodo);});
                    //Firebase add element
                    FirebaseFirestore.instance.collection("items")
                        .add({'item': userTodo});

                    Navigator.of(context).pop();
                  }, child: const Text("Add"))
              ],
            );
            } //builder
          ); // showDialog
        }, // onPressed
        child: const Icon(
        Icons.add,
        color: Colors.green,),
        ),
    );
  }
}