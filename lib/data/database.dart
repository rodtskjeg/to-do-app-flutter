import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];
  final myBox = Hive.box('toDoBox');

  void createInitialData() {
    toDoList = [
      ['My first Task', false],
    ];
  }

  void loadData() {
    toDoList = myBox.get('TODOLIST') ?? [];
  }

  void updateDataBase() {
    myBox.put('TODOLIST', toDoList);
  }
}
