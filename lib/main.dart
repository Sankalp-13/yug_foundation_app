import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yug_foundation_app/pages/home_page.dart';
import 'package:yug_foundation_app/providers/blogs/blogs_cubit.dart';
import 'package:yug_foundation_app/providers/sleep_tracker/sleep_tracker_cubit.dart';
import 'package:yug_foundation_app/providers/survey_home/survey_home_cubit.dart';
import 'package:yug_foundation_app/utils/colors.dart';

import 'pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MultiBlocProvider(
            providers: [
              BlocProvider<BlogsCubit>(
                create: (context) => BlogsCubit(),
              ),BlocProvider<SurveyHomeCubit>(
                create: (context) => SurveyHomeCubit(),
              ),BlocProvider<SleepTrackerCubit>(
                create: (context) => SleepTrackerCubit(),
              )
            ],
            child: const MyApp(),
          )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 390.11;
    precacheImage(const AssetImage("assets/sleep.png"), context);
    precacheImage(const AssetImage("assets/task.png"), context);
    precacheImage(const AssetImage("assets/period.png"), context);
    precacheImage(const AssetImage("assets/quiz.png"), context);
    precacheImage(const AssetImage("assets/blog.png"), context);
    precacheImage(const AssetImage("assets/survey.png"), context);
    return MaterialApp(
      title: 'Athena',
      theme: ThemeData(
        colorSchemeSeed: ColorConstants.mainThemeColor,
        useMaterial3: true,
        fontFamily: 'Akshar',
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 30 * w,
              fontWeight: FontWeight.w600,
              color: Colors.black),
          titleLarge: TextStyle(fontSize: 22 * w, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontSize: 14 * w, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16 * w, fontWeight: FontWeight.w600),
          labelSmall: TextStyle(
              fontSize: 13 * w,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: 0.2),
          headlineMedium: TextStyle(
              fontSize: 19 * w,
              fontWeight: FontWeight.w600,
              color: Colors.black),
          labelMedium: TextStyle(fontSize: 14 * w, fontWeight: FontWeight.w600),
        ),
      ),
      home: const HomePage(),
    );
  }
}
