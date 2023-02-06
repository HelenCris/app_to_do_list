import 'package:app_lista_de_tarefas/repositories/todo_repository.dart';
import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../widgets/todo_list_item.dart';

class ToDoListPage extends StatefulWidget {
  ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();
  String? errorText;

  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPosition;

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPosition = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso!',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.teal,
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPosition!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Limpar tudo?'),
                content: const Text(
                    'Você tem certeza que deseja apagar todas as tarefas?'),
                actions: [
                  TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.teal)),
                  TextButton(
                      child: const Text('Limpar Tudo'),
                      onPressed: () {
                        // deleteAllTodos;
                        setState(() {
                          todos.clear();
                        });
                        todoRepository.saveTodoList(todos);
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.red)),
                ]));
  }

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then(
      (value) {
        setState(() {
          todos = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Lista de Tarefas',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        hintText: 'Adicione uma Tarefa',
                        border: const OutlineInputBorder(),
                        errorText: errorText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState() =>
                              errorText = 'O título não pode ser vazio!';
                          return;
                        }
                        setState(() {
                          Todo newTodo =
                              Todo(title: text, dateTime: DateTime.now());
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(14)),
                      child: const Icon(Icons.add, size: 30))
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(todo: todo, onDelete: onDelete)
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: Text(
                          'Você possui ${todos.length} tarefas pendentes')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(14)),
                      child: const Text('Limpar Tudo'))
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
