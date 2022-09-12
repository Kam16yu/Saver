import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import '../database/dbhelper.dart';
import '/database/model.dart';
import 'package:flutter/widgets.dart';


class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      //Appbar, Setting Menu Button
      appBar: AppBar(
        title: const Text("Cards"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _menuOpen, icon: const Icon(Icons.menu_outlined))
        ],
      ),

      //Body
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<DbCard>>(
          future: fetchEmployeesFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 1,
                  itemBuilder: (context, index) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(snapshot.data?.elementAt(index).name ?? "2",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                          Text(snapshot.data?.elementAt(index).text ?? "3",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          Text(snapshot.data?.elementAt(index).time ?? "5",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          Image.memory(snapshot.data?.elementAt(index).pict ?? Uint8List(1)),
                          const Divider()
                        ]);
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Container(alignment: AlignmentDirectional.center,child: const CircularProgressIndicator(),);
          },
        ),
      ),

        // Add element Button
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            Navigator.pushNamed(context, '/createCard');
        }, // onPressed
        child: const Icon(
        Icons.add,
        color: Colors.green,),
        ),
    );
  }

  //Setting menu
  void _menuOpen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: const Text("Menu"),),
            body: Row(
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, '/createCard',
                          (route) => false);
                },child: const Text("To create page")
                ),
              ],
            ),
          );
        })
    );
  }

  Future<List<DbCard>> fetchEmployeesFromDatabase() async {
    var dbHelper = Dbhelper();
    Future<List<DbCard>> cards = dbHelper.getCards();
    return cards;
  }
}

