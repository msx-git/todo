import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:todo/core/utils/constants/app_colors.dart';
import 'package:todo/core/utils/extensions/sizedbox.dart';

import '../../data/models/todo.dart';
import '../../logic/blocs/todo/todos_bloc.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.todo});

  final Todo todo;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  /// INITIAL RATING
  double rate = 1;

  /// INITIAL RATING COLOR
  Color _containerColor = AppColors.rating1;

  /// RATING COLORS
  final List<Color> _colors = [
    AppColors.rating1,
    AppColors.rating2,
    AppColors.rating3,
    AppColors.rating4,
    AppColors.rating5,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(color: _containerColor),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              24.height,
              Text(
                "Baholash",
                style: GoogleFonts.carterOne(fontSize: 48.sp),
              ),
              Text(
                "Tell us you experience",
                style: TextStyle(
                  fontFamily: 'SFProText',
                  fontSize: 20.sp,
                  color: const Color(0xff000000).withOpacity(0.9),
                ),
              ),

              /// ANIMATED FREAKY FACES
              Expanded(
                child: Center(
                  child: Lottie.asset(
                    'assets/lotties/rate_${rate.toInt()}.json',
                    width: 327.w,
                    height: 360.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              /// RATE SLIDER
              SizedBox(
                width: 270.w,
                child: Slider(
                  value: rate,
                  divisions: 4,
                  min: 1,
                  max: 5,
                  onChanged: (value) {
                    setState(() {
                      rate = value;
                      _containerColor = _colors[rate.toInt() - 1];
                    });
                  },
                ),
              ),

              /// RATE BUTTON
              GestureDetector(
                onTap: () {
                  context.read<TodosBloc>().add(
                        RateTodo(
                          id: widget.todo.id,
                          rating: rate.toInt(),
                        ),
                      );
                  Navigator.pop(context);
                },
                child: Container(
                  width: 263.w,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  margin: EdgeInsets.symmetric(vertical: 20.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff000000),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Baholash',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xffFFFFFF),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
