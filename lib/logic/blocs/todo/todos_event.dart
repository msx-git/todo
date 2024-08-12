part of 'todos_bloc.dart';

sealed class TodosEvent {}

class AddTodo extends TodosEvent {
  final Todo todo;

  AddTodo(this.todo);
}

class ToggleTodo extends TodosEvent {
  final String id;

  ToggleTodo(this.id);
}

class RateTodo extends TodosEvent {
  final String id;
  final int rating;

  RateTodo({required this.id, required this.rating});
}

class LoadTodos extends TodosEvent {}
