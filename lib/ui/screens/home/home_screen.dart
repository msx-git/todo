import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/core/utils/constants/app_colors.dart';
import 'package:todo/core/utils/extensions/sizedbox.dart';
import 'package:todo/ui/screens/home/widgets/add_todo_widget.dart';
import 'package:todo/ui/screens/home/widgets/todo_item.dart';

import '../../../data/models/todo.dart';
import '../../../logic/blocs/todo/todos_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Map<String, List<Todo>> groupTodosByDate(List<Todo> todos) {
    final groupedTodos = groupBy(todos, (todo) {
      final now = DateTime.now();
      final todoDate = todo.dateTime;

      if (isSameDate(todoDate, now)) {
        return 'Bugun';
      } else if (isSameDate(todoDate, now.add(const Duration(days: 1)))) {
        return 'Ertaga';
      } else {
        return '${todoDate.day}/${todoDate.month}/${todoDate.year}';
      }
    });

    // Sort the keys so that "Bugun" comes first, then "Ertaga"
    final sortedKeys = groupedTodos.keys.toList()
      ..sort((a, b) {
        if (a == 'Bugun') return -1;
        if (b == 'Bugun') return 1;
        if (a == 'Ertaga') return -1;
        if (b == 'Ertaga') return 1;
        return a.compareTo(b);
      });

    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, groupedTodos[key]!)),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 14.21.w),
            child: CircleAvatar(
              child: Image.asset('assets/images/avatar.png'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        bloc: context.read<TodosBloc>()..add(LoadTodos()),
        builder: (context, state) {
          if (state is TodosInitial) {
            return const Center(child: Text("Starting to load todos..."));
          }
          if (state is TodosLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TodosError) {
            return Center(child: Text(state.errorMessage));
          }
          final todos = (state as TodosLoaded).todos;
          Map<String, List<Todo>> groupedTodos = groupTodosByDate(todos);
          return todos.isEmpty
              ? Center(
                  child: Text(
                    "Rejalar mavjud emas.\n\nQuyidagi + tugmasi bilan reja qo'shing.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SFProText',
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 14.21.w),
                  itemCount: groupedTodos.length,
                  itemBuilder: (BuildContext context, int index) {
                    String dateKey = groupedTodos.keys.elementAt(index);
                    List todosByDate = groupedTodos[dateKey]!;

                    /// Return a widget representing the dateKey and its items
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateKey,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SFProText',
                            fontSize: 26.9.sp,
                          ),
                        ),
                        30.height,
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: todosByDate.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Todo todo = todosByDate[index];
                            return TodoItem(todo: todo);
                          },
                        ),
                        20.height,
                      ],
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff262626),
        foregroundColor: const Color(0xffFAFAFA),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return const AddTodoWidget();
            },
          );
        },
        child: Icon(Icons.add, size: 40.r),
      ),
    );
  }
}
