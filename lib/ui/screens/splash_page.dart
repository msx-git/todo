import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../core/utils/constants/app_colors.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import 'auth_screen.dart';
import 'home/home_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(milliseconds: 2500),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocSelector<AuthBloc, AuthState, User?>(
              bloc: context.read<AuthBloc>()..add(WatchAuthEvent()),
              selector: (state) => state.user,
              builder: (context, user) {
                return user == null ? const AuthScreen() : const HomeScreen();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: double.infinity),
          Text(
            "Todify",
            style: GoogleFonts.concertOne(
              color: AppColors.purple,
              fontSize: 50.sp,
            ),
          ),
          SvgPicture.asset('assets/icons/splash_icon.svg'),
          Text(
            "Your Friendly Organizer",
            style: TextStyle(
              fontFamily: 'SFProText',
              color: AppColors.purple,
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
          Lottie.asset(
            'assets/lotties/loading.json',
            height: 140.h,
            width: 140.w,
          )
        ],
      ),
    );
  }
}
