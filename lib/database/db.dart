import 'package:hive_flutter/hive_flutter.dart';

class NoteDataBase {
  List notes = [];

  // reference our box
  final _notes = Hive.box('notes');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    notes = [
      // [
      //   "Packliste",
      //   "Laptop + Ladekabel bla bla bla bla bla bla bla bla bla bla\nHandy\nKopfhörer",
      //   DateTime(2020, 3, 4, 10).toString(),
      //   DateTime(2021, 3, 4, 10).toString(),
      //   100
      // ],
      // [
      //   "Einkaufen",
      //   "Karotten\nTomaten\nSchnitzel",
      //   DateTime(2023, 3, 4, 10).toString(),
      //   DateTime(2023, 3, 5, 12).toString(),
      //   -1
      // ],
    ];
  }

  // load the data from database
  void loadData() {
    notes = _notes.get("NOTES");
  }

  // update the database
  void updateDataBase() {
    _notes.put("NOTES", notes);
  }
}
