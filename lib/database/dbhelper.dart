import 'dart:async';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';


class Dbhelper {
  static Database? _db;

  Future<Database> get database async {

    if (_db != null) {
      return _db!;
    } else {_db = await dbInit();
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
        print("Create table");
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
    //
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

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('cards');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
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

    // Update the given Dog.
    await db.update('cards', card.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [card.id],
    );
  }

  Future<void> deleteCard(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'cards',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> simpleTest(DbCard card) async {
    // Create a Dog and add it to the dogs table
    var fido = DbCard(
        id: 0,
        name: 'Fido',
        text: "simple card text",
        pict: Uint8List(1),
        time: DateTime.now().toString(),
    );

    await insertCard(fido);

    // Now, use the method above to retrieve all the dogs.
    print(await getCards()); // Prints a list that include Fido.

    // Update Fido's age and save it to the database.
    fido = DbCard(
      id: fido.id,
      name: fido.name,
      text: "simple card text2",
      pict: Uint8List(1),
      time: DateTime.now().toString(),
    );

    await updateCard(fido);

    // Print the updated results.
    print(await getCards()); // Prints Fido with age 42.

    // Delete Fido from the database.
    await deleteCard(fido.id);

    // Print the list of cards (empty).
    print(await getCards());
  }
}
