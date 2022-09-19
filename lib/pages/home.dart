import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../database/dbhelper.dart';
import '/database/model.dart';


class Home extends StatefulWidget{
  const Home({Key? key,required this.camera}) : super(key: key);
  final CameraDescription camera;
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
          future: getFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 1,
                  itemBuilder: (context, index) {
                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),

                    child:InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.pushNamed(context, '/CreateCardScreen',
                            arguments: snapshot.data?.elementAt(index));
                      },

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          ListTile(
                            leading: Image.memory(snapshot.data?.elementAt(index)
                              .pict ?? Uint8List(1),
                            errorBuilder:  (BuildContext context,
    Object exception, StackTrace? stackTrace) {
                            return const Text("");
                            },
                            ),
                            title: Text(snapshot.data?.elementAt(index).name ??
                              "2"),
                            subtitle:Text(snapshot.data?.elementAt(index).text ??
                              "3",),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(snapshot.data?.elementAt(index).time ?? "5",
                                  style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)
                              ),
                              const SizedBox(width: 40),
                              TextButton(
                                child: const Text('CHANGE'),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/CreateCardScreen',
                                      arguments: snapshot.data?.elementAt(index));
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('DELETE'),
                                onPressed: () {
                                  var dbHelper = Dbhelper();
                                  dbHelper.deleteCard(snapshot.data?.
                                  elementAt(index).id ?? 0);
                                  setState(() {});
                                },
                              ),
                              const SizedBox(width: 8),
                            ],),
                        ]),
                    ));
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
          Navigator.pushNamed(context, '/CreateCardScreen');
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
                ElevatedButton(onPressed: () {
                  var dbHelper = Dbhelper();
                  dbHelper.deleteAll();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },child: const Text("Clear ALL")
                ),
              ],
            ),
          );
        })
    );
  }

  Future<List<DbCard>> getFromDatabase() async {
    var dbHelper = Dbhelper();
    Future<List<DbCard>> cards = dbHelper.getCards();
    return cards;
  }
}

