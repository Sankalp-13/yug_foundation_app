import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:yug_foundation_app/pages/widgets/bar_graph.dart';
import 'package:yug_foundation_app/providers/sleep_tracker/sleep_tracker_cubit.dart';
import 'package:yug_foundation_app/providers/sleep_tracker/sleep_tracker_states.dart';
import 'package:yug_foundation_app/utils/colors.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../domain/models/user_sleep_model.dart';

List<String> titles = <String>['Su', 'Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

class SleepTrackerPage extends StatefulWidget {
  const SleepTrackerPage({super.key});

  @override
  State<SleepTrackerPage> createState() => _SleepTrackerPageState();
}

class _SleepTrackerPageState extends State<SleepTrackerPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int notiID = 0;
  bool _notificationsEnabled = false;

  Future _initialize() async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    //var iOSInitialize =  IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(
        android: androidInitialize, iOS: const DarwinInitializationSettings());
    // iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(notiID, 'Time for bed',
        'Follow your schedule for a healthy sleep!', notificationDetails,
        payload: 'item x');
  }

  Future<void> _zonedScheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  String calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    int diff = DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (diff == -1) {
      return "Yesterday";
    } else if (diff == 0) {
      return 'Today';
    } else {
      return 'On ${DateFormat('d/M/y').format(date)}';
    }
  }

  @override
  void initState() {
    BlocProvider.of<SleepTrackerCubit>(context).checkIfAsleep();
    super.initState();
    _initialize();
    _isAndroidPermissionGranted();
    _requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark),
      body: SafeArea(
        child: BlocConsumer<SleepTrackerCubit, SleepTrackerState>(
            listener: (BuildContext context, SleepTrackerState state) {
          if (state is SleepTrackerErrorState) {
            SnackBar snackBar = SnackBar(
              content: Text(state.error),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }, builder: (context, state) {
          if (state is SleepTrackerLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstants.mainThemeColor,
              ),
            );
          }
          if (state is SleepTrackerSleepingState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                const SizedBox(
                  height: 28,
                ),
                Text('Sleep', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(
                  height: 34,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'You went to sleep at\n',
                    style: Theme.of(context).textTheme.titleLarge,
                    children: <TextSpan>[
                      TextSpan(
                        text: calculateDifference(state.sleptAt),
                        style: TextStyle(color: ColorConstants.mainThemeColor),
                      ),
                      TextSpan(
                          text: DateFormat(' h:mm a').format(state.sleptAt),
                          style:
                              TextStyle(color: ColorConstants.mainThemeColor)),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Lottie.asset(
                  'assets/sleeping.json',
                  height: screenWidth * 0.9,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: ColorConstants.mainThemeColor,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  onPressed: () {
                    BlocProvider.of<SleepTrackerCubit>(context).getSleepData();
                  },
                  child: Text(
                    "Are you awake? Stop tracking sleep?",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black45,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  onPressed: () {
                    BlocProvider.of<SleepTrackerCubit>(context).cancelSleep();
                  },
                  child: Text(
                    "Cancel Sleep",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black45,
                        ),
                  ),
                ),
              ],
            );
          }

          if (state is SleepTrackerLoadedState) {
            TimeOfDay scheduledBedTime = TimeOfDay.now();
            TimeOfDay scheduledWakeUpTime = TimeOfDay.now();

            late List<BarChartGroupData> showingBarGroups;
            double max = state.userSleep.days
                .reduce((curr, next) => curr > next ? curr : next);

            ///max value calc

            final barGroup1 = makeGroupData(0, state.userSleep.days[0], max);
            final barGroup2 = makeGroupData(1, state.userSleep.days[1], max);
            final barGroup3 = makeGroupData(2, state.userSleep.days[2], max);
            final barGroup4 = makeGroupData(3, state.userSleep.days[3], max);
            final barGroup5 = makeGroupData(4, state.userSleep.days[4], max);
            final barGroup6 = makeGroupData(5, state.userSleep.days[5], max);
            final barGroup7 = makeGroupData(6, state.userSleep.days[6], max);

            titles = ['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];
            showingBarGroups = [
              barGroup1,
              barGroup2,
              barGroup3,
              barGroup4,
              barGroup5,
              barGroup6,
              barGroup7,
            ];

            int count = 0;
            double sum = 0;
            for (double i in state.userSleep.days) {
              if (i != 0) {
                count++;
                sum += i;
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 28,
                ),
                Text('Sleep', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(
                  height: 34,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: count != 0
                        ? 'Your average sleep\neveryday is '
                        : "Let's start tracking your sleep hours!",
                    style: Theme.of(context).textTheme.titleLarge,
                    children: <TextSpan>[
                      TextSpan(
                          text: count != 0 ? '$sum' : '',
                          style:
                              TextStyle(color: ColorConstants.mainThemeColor)),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    height: screenHeight * 0.29,
                    padding: const EdgeInsets.all(8),
                    child: CustomBarGraph(
                      max: max,
                      showingBarGroups: showingBarGroups,
                      days: titles,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.4,
                      height: 81,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(
                            color: Colors.grey.shade300, width: 1.5)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "☀️ Sleep Rate   ",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                          ),
                          Text(
                            "82%",
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.4,
                      height: 81,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(
                            color: Colors.grey.shade300, width: 1.5)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "😴 Going to sleep now?",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            height: 28,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        ColorConstants.mainThemeColor,
                                    foregroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
                                onPressed: () {
                                  // UserSleep userSleep = UserSleep();
                                  // userSleep.sleptAt=DateTime.now();
                                  // String s =jsonEncode(userSleep.toJson());
                                  // print(s);
                                  // UserSleep ss = UserSleep.fromJson(jsonDecode(s));
                                  // print(ss.sleptAt!.year);
                                  BlocProvider.of<SleepTrackerCubit>(context)
                                      .goToSleep(DateTime.now());
                                },
                                child: const Text("Confirm")),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Align(
                //       alignment: Alignment.centerLeft,
                //       child: Text(
                //         "Set your Schedule",
                //         style: Theme.of(context)
                //             .textTheme
                //             .titleLarge
                //             ?.copyWith(fontSize: 18),
                //       )),
                // ),
                // const SizedBox(
                //   height: 4,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap: () async {
                //         final TimeOfDay? pickedTime = await showTimePicker(
                //           context: context,
                //           initialTime: scheduledBedTime,
                //           builder: (context, child) {
                //             return Theme(
                //               data: ThemeData.light().copyWith(
                //                   colorScheme: ColorScheme.fromSeed(
                //                       seedColor: ColorConstants.accentColor)),
                //               child: child!,
                //             );
                //           },
                //         );
                //
                //         if (pickedTime != null && pickedTime != scheduledBedTime)
                //           setState(() {
                //             scheduledBedTime = pickedTime;
                //           });
                //       },
                //       child: Container(
                //         width: screenWidth * 0.4,
                //         height: 80,
                //         padding: const EdgeInsets.all(12),
                //         decoration: BoxDecoration(
                //           color: ColorConstants.accentColor,
                //           borderRadius:
                //               const BorderRadius.all(Radius.circular(16)),
                //         ),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Text(
                //               "🛏 Bedtime",
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .titleSmall
                //                   ?.copyWith(
                //                       fontWeight: FontWeight.w400,
                //                       color: Colors.black45),
                //             ),
                //             const SizedBox(
                //               height: 4,
                //             ),
                //             // Row(
                //             //   crossAxisAlignment: CrossAxisAlignment.end,
                //             //   children: [
                //             //     Text(
                //             // '${scheduledBedTime.hour}:${scheduledBedTime.minute}',
                //             //       style: Theme.of(context)
                //             //           .textTheme
                //             //           .titleLarge
                //             //           ?.copyWith(color: Colors.black45),
                //             //     ),
                //             //     const SizedBox(
                //             //       width: 4,
                //             //     ),
                //             //     Text(
                //             //       "${scheduledBedTime.period.toString().split('.')[1]}",
                //             //       style: Theme.of(context)
                //             //           .textTheme
                //             //           .titleSmall
                //             //           ?.copyWith(
                //             //               fontWeight: FontWeight.w400,
                //             //               color: Colors.black45),
                //             //     ),
                //             //   ],
                //             // )
                //           ],
                //         ),
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () async {
                //         final TimeOfDay? pickedTime = await showTimePicker(
                //           context: context,
                //           initialTime: scheduledWakeUpTime,
                //           builder: (context, child) {
                //             return Theme(
                //               data: ThemeData.light().copyWith(
                //                   colorScheme: ColorScheme.fromSeed(
                //                       seedColor: ColorConstants.darkWidgetColor)),
                //               child: child!,
                //             );
                //           },
                //         );
                //
                //         if (pickedTime != null && pickedTime != scheduledWakeUpTime)
                //           setState(() {
                //             scheduledWakeUpTime = pickedTime;
                //           });
                //       },
                //       child: Container(
                //         width: screenWidth * 0.4,
                //         height: 80,
                //         padding: const EdgeInsets.all(12),
                //         decoration: BoxDecoration(
                //           color: ColorConstants.darkWidgetColor,
                //           borderRadius:
                //               const BorderRadius.all(Radius.circular(16)),
                //         ),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Text(
                //               "⏰ Wake up",
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .titleSmall
                //                   ?.copyWith(
                //                       fontWeight: FontWeight.w400,
                //                       color: Colors.white),
                //             ),
                //             const SizedBox(
                //               height: 4,
                //             ),
                //             // Row(
                //             //   crossAxisAlignment: CrossAxisAlignment.end,
                //             //   children: [
                //             //     Text(
                //             //       '${scheduledWakeUpTime.hour}:${scheduledWakeUpTime.minute}',
                //             //       style: Theme.of(context)
                //             //           .textTheme
                //             //           .titleLarge
                //             //           ?.copyWith(color: Colors.white),
                //             //     ),
                //             //     const SizedBox(
                //             //       width: 4,
                //             //     ),
                //             //     Text(
                //             //       "${scheduledWakeUpTime.period.toString().split('.')[1]}",
                //             //       style: Theme.of(context)
                //             //           .textTheme
                //             //           .titleSmall
                //             //           ?.copyWith(
                //             //               fontWeight: FontWeight.w400,
                //             //               color: Colors.white),
                //             //     ),
                //             //   ],
                //             // )
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            );
          }
          return const Center(
            child: Text("Something went wrong!"),
          );
        }),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double max) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
            toY: y1,
            color: DateTime.now().weekday - 2 % 7 == x
                ? ColorConstants.darkWidgetColor
                : ColorConstants.lightWidgetColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            width: 32,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: max,
              color: Colors.grey[200],
            )),
      ],
    );
  }
}
