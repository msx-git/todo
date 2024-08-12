import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import '../../ui/screens/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) {
        return const ToastificationWrapper(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashPage(),
          ),
        );
      },
    );
  }
}
