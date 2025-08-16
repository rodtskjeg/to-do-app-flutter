import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final bool taskCompleted;
  final String taskTitle;
  final Function(bool?)? onChanged;
  final Function(BuildContext) onDelete;

  const ToDoTile({
    super.key,
    this.taskCompleted = false,
    this.taskTitle = 'My first Task',
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(10),
              onPressed: (context) {
                onDelete(context);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                taskTitle,
                style: TextStyle(
                  fontSize: 20,
                  color: taskCompleted ? Colors.grey[600] : Colors.black,
                  decoration:
                      taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                ),
              ),
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                activeColor: Colors.orange,
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
