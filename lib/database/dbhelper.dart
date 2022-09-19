import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';


class Dbhelper {
  static Database? _db;
  // setting getter for database object
  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {_db = await dbInit(); // first run
    return _db!;
    }
  }

  dbInit() async {
    // Open the database and store the reference.
    var db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'cards_database.db'),
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE cards (id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' name TEXT, text TEXT, pict BLOB, time TEXT)',
        );
      },
    );
    return db;
  }

  // Define a function that inserts dogs into the database
  Future<void> insertCard(DbCard card) async {
    // Get a reference to the database.
    final db = await database;
    // Insert the Card into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    // In this case, replace any previous data.
    await db.insert(
      'cards',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<DbCard>> getCards() async {
    // Get a reference to the database.
    final db = await database;
    // Query the table for all Cards.
    final List<Map<String, dynamic>> maps = await db.query('cards');
    // Convert the List<Map<String, dynamic> into a List<Card>.
    return List.generate(maps.length, (i) {
      return DbCard(
        id: maps[i]['id'],
        name: maps[i]['name'],
        text: maps[i]['text'],
        pict: maps[i]['pict'],
        time: maps[i]['time'],
      );
    });
  }

  Future<void> updateCard(DbCard card) async {
    // Get a reference to the database.
    final db = await database;
    // Update the given Card.
    await db.update('cards', card.toMap(),
      // Ensure that the Card has a matching id.
      where: 'id = ?',
      // Pass the Card id as a whereArg to prevent SQL injection.
      whereArgs: [card.id],
    );
  }

  Future<bool> deleteCard(int id) async {
    // Get a reference to the database.
    final db = await database;
    // Remove the Card from the DB.
    int rowsEffected = await db.delete(
      'cards',
      // Use a `where` clause to delete a specific card.
      where: 'id = ?',
      // Pass the Card id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }

  // delete all notes
  Future<bool> deleteAll() async {
    final Database db = await database;
    int changes = await db.rawDelete('DELETE FROM cards');
    return changes > 0;
  }

  Future <int> maxId() async {
  var maxid = 1;
  final db = await database;
  // get max id from DB
  await db.query('cards', where: "id=(SELECT MAX(id) FROM cards)").then((value){
    if (value.isNotEmpty) {
    maxid = int.parse(value[0]['id'].toString());
    return maxid;}
    }); //then query
  return maxid;
  }


}
