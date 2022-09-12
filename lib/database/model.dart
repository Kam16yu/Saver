import 'dart:typed_data';

class DbCard {
  var id = 1;
  var name = "null name";
  var text = "null text";
  var pict = Uint8List(1);
  var time = "null time";
  //Constructors
  DbCard({required this.id, required this.name, required this.text,
    required this.pict, required this.time});

  DbCard.fromMap(Map map) {
    name = map[name];
    text = map[text];
    pict = map[pict];
    time = map[time];
  }


  // Convert a Card into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'text': text,
      'pict': pict,
      'time': time
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Card{id: $id, name: $name, text: $text, time: $time}';
  }
}

