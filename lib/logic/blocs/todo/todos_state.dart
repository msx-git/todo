part of 'todos_bloc.dart';

sealed class TodosState {}

final class TodosInitial extends TodosState {}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final List<Todo> todos;

  TodosLoaded(this.todos);
}

class TodosError extends TodosState {
  final String errorMessage;

  TodosError(this.errorMessage);
}