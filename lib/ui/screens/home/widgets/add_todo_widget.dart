import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/core/utils/extensions/sizedbox.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../data/models/todo.dart';
import '../../../../logic/blocs/todo/todos_bloc.dart';

class AddTodoWidget extends StatefulWidget {
  const AddTodoWidget({super.key});

  @override
  State<AddTodoWidget> createState() => _AddTodoWidgetState();
}

class _AddTodoWidgetState extends State<AddTodoWidget> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDateTime;
  bool _isToday = true;
  final _formKey = GlobalKey<FormState>();

  void _onTimeChanged(DateTime time) {
    setState(() {
      _selectedDateTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: const Color(0xffF9F9F9),
          borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          14.height,
          CupertinoNavigationBar(
            backgroundColor: const Color(0xffF9F9F9),
            padding: EdgeInsetsDirectional.zero,
            leading: TextButton.icon(
              onPressed: () {},
              label: Text(
                'Orqaga',
                style: TextStyle(
                  fontFamily: 'SfProText',
                  color: AppColors.blue,
                  fontSize: 17.sp,
                ),
              ),
              icon: const Icon(
                CupertinoIcons.chevron_left,
                color: AppColors.blue,
              ),
            ),
            // leading: Text("Orqaga"),
            middle: const Text("Reja"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 29.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                32.height,
                Text(
                  "Reja qo’shish",
                  style: TextStyle(
                    fontSize: 34.sp,
                    fontFamily: 'SfProDisplay',
                    fontWeight: FontWeight.w700,
                    height: 1.h,
                  ),
                ),
                25.height,

                /// TITLE INPUT
                Row(
                  children: [
                    Text(
                      "Nomi",
                      style: TextStyle(
                        fontFamily: "SfProDisplay",
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                      ),
                    ),
                    23.width,
                    Expanded(
                      child: SizedBox(
                        height: 32.h,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: 'Reja nomini kiriting',
                              hintStyle: TextStyle(
                                fontFamily: 'SfProText',
                                fontSize: 12.89.sp,
                                color: const Color(0xff3C3C43).withOpacity(0.3),
                              ),
                              contentPadding: EdgeInsets.only(bottom: 14.h),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xff3C3C43).withOpacity(0.3),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Reja nomini kiriting!";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                25.height,

                /// TIME INPUT
                Row(
                  children: [
                    Text(
                      "Vaqti",
                      style: TextStyle(
                        fontFamily: "SfProDisplay",
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                      ),
                    ),
                    23.width,
                    CustomTimePicker(
                      onTimeChanged: _onTimeChanged,
                    ),
                  ],
                ),
                25.height,

                /// DATE CHOOSING [TODAY or TOMORROW]
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bugun ",
                      style: TextStyle(
                        fontFamily: "SfProDisplay",
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                      ),
                    ),
                    23.width,
                    CupertinoSwitch(
                      value: _isToday,
                      onChanged: (value) => setState(() => _isToday = value),
                    ),
                  ],
                ),
                60.height,

                /// ADD TODO BUTTON
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final todoTime = _isToday
                          ? _selectedDateTime
                          : _selectedDateTime?.add(const Duration(days: 1));
                      if (todoTime != null) {
                        context.read<TodosBloc>().add(
                              AddTodo(
                                Todo(
                                  id: UniqueKey().toString(),
                                  title: _titleController.text,
                                  dateTime: todoTime,
                                ),
                              ),
                            );
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.06.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff171717),
                      borderRadius: BorderRadius.circular(11.58.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Qo'shish",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SfProText',
                        fontSize: 14.06.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.68.h),
                Center(
                  child: Text(
                    'Agar siz bugunni o‘chirib qo‘ysangiz, vazifa ertaga deb hisoblanadi',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'SfProText',
                      color: const Color(0xff3C3C43).withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomTimePicker extends StatefulWidget {
  final Function(DateTime) onTimeChanged;

  const CustomTimePicker({super.key, required this.onTimeChanged});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  int _selectedHour = 1;
  int _selectedMinute = 0;
  bool _isAM = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedHour = now.hour > 12 ? now.hour - 12 : now.hour;
    _selectedMinute = now.minute;
    _isAM = now.hour < 12;
  }

  void _toggleAMPM() {
    setState(() {
      _isAM = !_isAM;
      _notifyTimeChanged(); // Notify parent of time change
    });
  }

  void _notifyTimeChanged() {
    final selectedTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _isAM ? _selectedHour : _selectedHour + 12,
      _selectedMinute,
    );

    widget.onTimeChanged(selectedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff767680).withOpacity(0.12),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HOUR
              Container(
                width: 40.w,
                height: 45.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                child: CupertinoPicker(
                  backgroundColor: Colors.transparent,
                  selectionOverlay: const SizedBox(),
                  scrollController: FixedExtentScrollController(
                    initialItem: _selectedHour - 1,
                  ),
                  itemExtent: 28.h,
                  onSelectedItemChanged: (int value) {
                    setState(() {
                      _selectedHour = value + 1;
                      _notifyTimeChanged();
                    });
                  },
                  children: List.generate(
                    12,
                    (index) => Text(
                      "${index + 1}",
                      style: TextStyle(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                ":",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontFamily: 'SfProDisplay',
                ),
              ),

              /// MINUTE
              Container(
                width: 40.w,
                height: 45.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                child: CupertinoPicker(
                  backgroundColor: Colors.transparent,
                  selectionOverlay: const SizedBox(),
                  scrollController: FixedExtentScrollController(
                    initialItem: _selectedMinute,
                  ),
                  itemExtent: 28.h,
                  onSelectedItemChanged: (int value) {
                    setState(() {
                      _selectedMinute = value;
                      _notifyTimeChanged();
                    });
                  },
                  children: List.generate(
                    60,
                    (index) => Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        10.width,
        GestureDetector(
          onTap: _toggleAMPM,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              _isAM ? ' AM ' : ' PM ',
              style: TextStyle(
                fontFamily: 'SfProText',
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
