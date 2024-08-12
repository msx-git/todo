import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

class TodosRepository {
  Future<List<Todo>> loadTodosFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString('todos');
    if (todosJson != null) {
      List<dynamic> jsonList = jsonDecode(todosJson);
      return jsonList.map((json) => Todo.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveTodosToLocalStorage(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final String todosJson =
        jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', todosJson);
  }
}
