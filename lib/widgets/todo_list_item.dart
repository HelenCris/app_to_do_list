import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({super.key, required this.todo, required this.onDelete});

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
                // An action can be bigger than the others.
                flex: 2,
                onPressed: (context) => onDelete(todo),
                backgroundColor: Colors.red,
                icon: Icons.delete,
                label: 'Delete'),
          ],
        ),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  todo.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                )
              ],
            )),
      ),
    );
  }
}
