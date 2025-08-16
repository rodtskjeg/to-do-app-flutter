import 'package:flutter/material.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/utils/to_do_tile.dart';
import 'package:to_do_app/utils/dialo_box.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// This is the state class for HomePage, which manages the state of the to-do list
class _HomePageState extends State<HomePage> {
  // Initialize Hive and open the box for persistent storage
  final myBox = Hive.box('toDoBox');
  // Instance of the ToDoDatabase class
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    super.initState();
    if (myBox.get("TODOLIST") == null) {
      db.createInitialData(); // Create initial data for the to-do list
    } else {
      db.loadData(); // Load existing data from the Hive box
    }
  }

  // Reference to the Hive box for persistent storage
  final TextEditingController controller =
      TextEditingController(); // Controller for the text input

  List toDoList = []; // Initial to-do list with one task

  // Function to toggle the checkbox state
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
      db.updateDataBase(); // Update the database after changing the state
    });
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([controller.text, false]);
      controller.clear();
      Navigator.of(context).pop(); // Close the dialog
    });
    db.updateDataBase(); // Update the database with the new task
  }

  // Function to create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          title: "What is your task?",
          hintText: "Give me Text!",
          controller: controller,
          onSave: saveNewTask,
          onCancel: () {
            Navigator.of(context).pop(); // Close the dialog on cancel
          },
        );
      },
    );
  }

  // Function to delete a task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
      db.updateDataBase(); // Update the database after deletion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter App')),
      backgroundColor: Colors.yellow[100],
      body:
          db.toDoList.isEmpty
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "No Tasks Yet!",
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: createNewTask,
                    child: const Text("Add Task", style: TextStyle(fontSize: 15, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              )
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: ListView.builder(
                  itemCount: db.toDoList.length,
                  itemBuilder: (context, index) {                    return ToDoTile(
                      taskCompleted: db.toDoList[index][1],
                      taskTitle: db.toDoList[index][0],
                      onChanged: (value) => checkBoxChanged(value, index),
                      onDelete: (context) => deleteTask(index),
                    );
                  },
                ),
              ),
      floatingActionButton:
          db.toDoList.isEmpty
              ? null
              : FloatingActionButton(
                onPressed: createNewTask,
                child: const Icon(Icons.add),
                backgroundColor: Colors.orange,
              ),
    );
  }
}
