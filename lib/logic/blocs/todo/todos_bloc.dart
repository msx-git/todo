import 'package:bloc/bloc.dart';

import '../../../data/models/todo.dart';
import '../../../data/repositories/todos_repository.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository _todosRepository;

  TodosBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(TodosInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<RateTodo>(_onRateTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodosState> emit) async {
    emit(TodosLoading());
    try {
      final todos = await _todosRepository.loadTodosFromLocalStorage();
      emit(TodosLoaded(todos));
    } catch (e) {
      emit(TodosError('Failed to load todos: $e'));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodosState> emit) async {
    List<Todo> existingTodos = [];
    if (state is TodosLoaded) {
      existingTodos = List<Todo>.from((state as TodosLoaded).todos);
    }
    emit(TodosLoading());
    try {
      final newTodo = event.todo;
      existingTodos.add(newTodo);
      await _todosRepository.saveTodosToLocalStorage(existingTodos);
      emit(TodosLoaded(existingTodos));
    } catch (e) {
      emit(TodosError('Failed to add todos: $e'));
    }
  }

  Future<void> _onToggleTodo(ToggleTodo event, Emitter<TodosState> emit) async {
    try {
      final updatedTodos = (state as TodosLoaded).todos.map((todo) {
        if (todo.id == event.id) {
          return todo.copyWith(isDone: !todo.isDone);
        }
        return todo;
      }).toList();
      await _todosRepository.saveTodosToLocalStorage(updatedTodos);
      emit(TodosLoaded(updatedTodos));
    } catch (e) {
      emit(TodosError('Failed to toggle todos: $e'));
    }
  }

  Future<void> _onRateTodo(RateTodo event, Emitter<TodosState> emit) async {
    try {
      final updatedTodos = (state as TodosLoaded).todos.map((todo) {
        if (todo.id == event.id) {
          return todo.copyWith(rating: event.rating,isDone: true);
        }
        return todo;
      }).toList();
      await _todosRepository.saveTodosToLocalStorage(updatedTodos);
      emit(TodosLoaded(updatedTodos));
    } catch (e) {
      emit(TodosError('Failed to toggle todos: $e'));
    }
  }
}
