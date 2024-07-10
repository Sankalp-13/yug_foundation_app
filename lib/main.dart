import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:yug_foundation_app/pages/home_page.dart';
import 'package:yug_foundation_app/pages/login_signup/login_page.dart';
import 'package:yug_foundation_app/providers/blogs/blogs_cubit.dart';
import 'package:yug_foundation_app/providers/login_signup/login_signup_cubit.dart';
import 'package:yug_foundation_app/providers/profile/profile_cubit.dart';
import 'package:yug_foundation_app/providers/quiz/quiz_cubit.dart';
import 'package:yug_foundation_app/providers/sleep_tracker/sleep_tracker_cubit.dart';
import 'package:yug_foundation_app/providers/survey_home/survey_home_cubit.dart';
import 'package:yug_foundation_app/providers/tasks/task_cubit.dart';
import 'package:yug_foundation_app/utils/colors.dart';

import 'domain/models/profile_response_model.dart';


Widget _defaultHome = const LoginPage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  const storage = FlutterSecureStorage();
  await storage.containsKey(key: "accessToken").then((value) async {
    await storage.read(key: "profile").then((user) {
      if (value&&user!=null) {
        _defaultHome = HomePage(profileResponseModel: ProfileResponseModel.fromJson(jsonDecode((user)) ));
      }else {
        /// This statement does not do anything meaningful since we already initialized at _defaultHome with IntroPage
        _defaultHome = const LoginPage();
      }
    });
  });

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
              ),BlocProvider<LoginCubit>(
                create: (context) => LoginCubit(),
              ),BlocProvider<TasksCubit>(
                create: (context) => TasksCubit(),
              ),BlocProvider<QuizCubit>(
                create: (context) => QuizCubit(),
              ),BlocProvider<ProfileCubit>(
                create: (context) => ProfileCubit(),
              ),
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
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) { //ignored progress for the moment
        return Center(
          child: CircularProgressIndicator(
            color: ColorConstants.mainThemeColor,
          ),
        );
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
        home: _defaultHome,
      ),
    );
  }
}
