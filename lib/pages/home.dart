import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
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
  final player = AudioPlayer();

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
                    //PRESS SPLASH
                    child:InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.pushNamed(context, '/CreateCardScreen',
                            arguments: snapshot.data?.elementAt(index));
                      },
                      //CARD BODY
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                          leading:Image.memory(snapshot.data?.elementAt(index)
                                  .pict ?? Uint8List(1),
                                  errorBuilder:  (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                  return const Text("");
                                  },),
                          title: Text(snapshot.data?.elementAt(index).name ?? "2"),
                          subtitle:Text(snapshot.data?.elementAt(index).text ?? "3",),
                          ),
                          if (snapshot.data!.elementAt(index).rec.length > 1)
                          Card(child: Row(
                              children:[
                                IconButton(
                                    padding: const EdgeInsets.fromLTRB(8.0,8.0,20.0,8.0),
                                    icon: const Icon(Icons.play_arrow),
                                    onPressed: () async{
                                      await player.setSourceBytes(snapshot.data!.elementAt(index).rec);
                                      await player.resume();
                                    }),
                                IconButton(
                                    padding: const EdgeInsets.fromLTRB(8.0,8.0,20.0,8.0),
                                    icon: const Icon(Icons.pause),
                                    onPressed: () async{
                                      await player.pause();
                                    }),
                                IconButton(
                                    padding: const EdgeInsets.fromLTRB(8.0,8.0,20.0,8.0),
                                    icon: const Icon(Icons.stop),
                                    onPressed: () async{
                                      await player.stop();
                                    }),
                              ]),),
                          //CARD BUTTONS
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

