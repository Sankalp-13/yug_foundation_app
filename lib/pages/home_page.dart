import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:yug_foundation_app/pages/blogs_page.dart';
import 'package:yug_foundation_app/pages/profile_page.dart';
import 'package:yug_foundation_app/pages/quiz_page/quiz_home_page.dart';
import 'package:yug_foundation_app/pages/sleep_tracker_page.dart';
import 'package:yug_foundation_app/pages/survey_home_page.dart';
import 'package:yug_foundation_app/pages/task_page.dart';

import '../domain/models/profile_response_model.dart';
import '../utils/colors.dart';
import 'chatbot_page.dart';
import 'period_tracker_dashboard.dart';

class HomePage extends StatefulWidget {
  ProfileResponseModel profileResponseModel;

  HomePage({Key? key, required this.profileResponseModel}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "User";

  final keepAlive = InAppWebViewKeepAlive();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    double h = MediaQuery.of(context).size.height / 844.24;
    double w = MediaQuery.of(context).size.width / 390.11;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.mainThemeColor,
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
           SizedBox(
            height: screenHeight*0.013,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hey,",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "${widget.profileResponseModel.name}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  height: 50,
                  child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfilePage()));
                      },
                      icon: const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 48,
                      )),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: Container(
              width: screenWidth,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              // Add padding for content spacing
              decoration: const BoxDecoration(
                color: Colors.white, // Set box color to white
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  // Add rounded corners to the top left
                  topRight: Radius.circular(
                      32), // Add rounded corners to the top right
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align text to the left
                  children: [
                    const SizedBox(height: 20),
                    // Add spacing below the heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SquareButton(
                          label: 'Sleep Tracker',
                          widgetHeight: screenHeight * 0.148,
                          widgetWidth: screenWidth * 0.43,
                          child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Image(
                                  image: AssetImage(
                                "assets/sleep.png",
                              ))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SleepTrackerPage()));
                          },
                        ),
                        SquareButton(
                          label: 'Tasks',
                          widgetHeight: screenHeight * 0.148,
                          widgetWidth: screenWidth * 0.43,
                          child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Image(
                                  image: AssetImage(
                                "assets/task.png",
                              ))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TaskPage()));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SquareButton(
                          label: 'Period Tracker',
                          widgetHeight: screenHeight * 0.148,
                          widgetWidth: screenWidth * 0.43,
                          child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Image(
                                  image: AssetImage(
                                "assets/period.png",
                              ))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PeriodDashboard()));
                          },
                        ),
                        SquareButton(
                          label: 'Quizzes',
                          widgetHeight: screenHeight * 0.148,
                          widgetWidth: screenWidth * 0.43,
                          child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Image(
                                  image: AssetImage(
                                "assets/quiz.png",
                              ))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const QuizHomePage()));
                          },
                        ),
                      ],
                    ),
                    // SizedBox(height: 10,),
                    // const Text(
                    //   'Others',
                    //   style: TextStyle(
                    //       fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 30),

                    const SizedBox(height: 20),
                    SquareButton(
                      label: null,
                      widgetHeight: null,
                      widgetWidth: screenWidth * 0.9,
                      onPressed: null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                            "We at YUG Foundation work towards bringing to life and meaning to our motto Sahyog, Seva, Samarpan.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                      ),
                    ),

                    SizedBox(height: 26 * h),
                    // const Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SquareButton(
                          label: null,
                          widgetHeight: screenHeight * 0.148,
                          widgetWidth: screenWidth * 0.43,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, top: 12),
                                child: Text(
                                  "Blogs",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.43,
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Image(
                                      image: const AssetImage(
                                        "assets/blog.png",
                                      ),
                                      height: screenHeight * 0.11)),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BlogsPage()));
                          },
                        ),
                        SquareButton(
                          label: null,
                          widgetHeight: screenHeight * 0.148,
                          widgetWidth: screenWidth * 0.43,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, top: 12),
                                child: Text(
                                  "Survey",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.43,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Image(
                                  image: const AssetImage("assets/survey.png"),
                                  height: screenHeight * 0.11,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SurveyHomepage()));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // SquareButton(
                    //   label: null,
                    //   widgetHeight: null,
                    //   widgetWidth: screenWidth * 0.9,
                    //   onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatBotWidget()));},
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 16.0),
                    //     child: Text("We have a chatbot helper coming soon!",textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.w500)),
                    //   ),
                    // ),
                    Offstage(
                      offstage: true,
                      child: InAppWebView(
                        keepAlive: keepAlive,
                        initialUrlRequest: URLRequest(
                          url: WebUri(
                              "https://storage.googleapis.com/athena-chat/index.html"),
                        ),
                        initialSettings: InAppWebViewSettings(
                            supportZoom: false,
                            builtInZoomControls: false),
                      ),
                    ),
                    const SizedBox(height: 9),
                  ],
                ),
              ),
              //   ],
              // ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 74,
        width: 74,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatBotWidget(keepAlive: keepAlive,)));
            },
            backgroundColor: ColorConstants.accentColor,
            child: Icon(
              Icons.chat_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class SquareButton extends StatefulWidget {
  final String? label;
  final double? widgetHeight;
  final double? widgetWidth;
  final Widget child;
  final void Function()? onPressed;

  const SquareButton({
    required this.label,
    required this.widgetHeight,
    required this.widgetWidth,
    required this.onPressed,
    required this.child,
  });

  @override
  State<SquareButton> createState() => _SquareButtonState();
}

class _SquareButtonState extends State<SquareButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.widgetHeight,
          width: widget.widgetWidth,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              // elevation: 0,
              splashFactory: NoSplash.splashFactory,
              padding: const EdgeInsets.all(0),
              backgroundColor: ColorConstants.lightWidgetColor,
              disabledBackgroundColor: ColorConstants.lightWidgetColor,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(24.0), // Adjust the value as needed
              ),
            ),
            child: widget.child,
          ),
        ),
        const SizedBox(height: 5),
        widget.label != null
            ? Text(widget.label!,
                style: Theme.of(context).textTheme.labelMedium)
            : Container(),
      ],
    );
  }
}

class CircularButton extends StatelessWidget {
  final String label;
  final String iconAddress;
  final void Function() onPress;

  const CircularButton(
      {super.key,
      required this.label,
      required this.iconAddress,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            backgroundColor: const Color(0xFF5A4EAB),
            shape: const CircleBorder(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ImageIcon(
              AssetImage(iconAddress),
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
