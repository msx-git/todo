import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:todo/core/utils/extensions/sizedbox.dart';
import 'package:todo/ui/screens/rating_screen.dart';

import '../../../../data/models/todo.dart';
import '../../../../logic/blocs/todo/todos_bloc.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: todo.isDone || todo.dateTime.day != DateTime.now().day
          ? null
          : () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => RatingScreen(todo: todo)),
              );
            },
      child: Row(
        children: [
          todo.dateTime.day == DateTime.now().day
              ? TodoCheckbox(todo: todo)
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 18.w),
                  width: 7.91.w,
                  height: 7.91.h,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w500,
                    color: todo.isDone
                        ? const Color(0xFF000000).withOpacity(0.3)
                        : const Color(0xff737373),
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                    decorationColor: const Color(0xFF000000).withOpacity(0.3),
                  ),
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat("h:mm a").format(todo.dateTime),
                      style: TextStyle(
                        fontSize: 10.28.sp,
                        fontFamily: 'SFProText',
                        fontWeight: FontWeight.w500,
                        color: todo.isDone
                            ? const Color(0xFF000000).withOpacity(0.3)
                            : const Color(0xffA3A3A3),
                        decoration:
                            todo.isDone ? TextDecoration.lineThrough : null,
                        decorationColor:
                            const Color(0xFF000000).withOpacity(0.3),
                      ),
                    ),
                    if (todo.rating != 0)
                      Text(
                        "Baho: ${todo.rating}",
                        style: TextStyle(
                          fontSize: 10.28.sp,
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w500,
                          color: todo.isDone
                              ? const Color(0xFF000000).withOpacity(0.3)
                              : const Color(0xffA3A3A3),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TodoCheckbox extends StatelessWidget {
  const TodoCheckbox({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: todo.isDone,
      onChanged: (value) {
        context.read<TodosBloc>().add(ToggleTodo(todo.id));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      activeColor: Colors.black,
    );
  }
}
