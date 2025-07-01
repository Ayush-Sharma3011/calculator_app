import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  final _myBox = Hive.box('myBox');
  List<String> history = [];

  // load the data from database
  void loadData() {
    history = _myBox.get('HISTORY', defaultValue: <String>[]).cast<String>();
  }

  // update the database
  void updateDatabase() {
    _myBox.put('HISTORY', history);
  }
}