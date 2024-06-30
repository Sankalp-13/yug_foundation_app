import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/colors.dart';
import 'widgets/custom_calendar.dart';
import 'widgets/get_period_data.dart';
import 'widgets/period_calc.dart';

class PeriodDashboard extends StatefulWidget {
  const PeriodDashboard({Key? key}) : super(key: key);

  @override
  State<PeriodDashboard> createState() => _PeriodDashboardState();
}

class _PeriodDashboardState extends State<PeriodDashboard> {
  @override
  void initState() {
    checkPeriodData().then((value) {
      setState(() {
        periodLength;
        cycleLength;
        lastPeriod;
      });
    });
  }

  int periodLength = 4;
  int cycleLength = 28;
  DateTime lastPeriod = DateTime.now();

  Future<void> checkPeriodData() async {
    final storage = const FlutterSecureStorage();
    if (await storage.containsKey(key: 'PERIOD_LENGTH')) {
      periodLength = int.parse((await storage.read(key: 'PERIOD_LENGTH'))!);
      cycleLength = int.parse((await storage.read(key: 'CYCLE_LENGTH'))!);
      lastPeriod = DateTime.parse((await storage.read(key: 'LAST_PERIOD'))!);
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const GetPeriodDataPage()));
    }
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
          systemOverlayStyle: SystemUiOverlayStyle.dark
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 28,
              ),
              Text(
                "Period Tracker",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(
                height: 12,
              ),
              CalendarPage(
                firstMensurationDay: lastPeriod,
                cycleLength: cycleLength,
                numberOfDays: periodLength,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const GetPeriodDataPage()));
                },
                child: Container(
                    width: screenWidth * 0.9,
                    height: screenHeight*0.06,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(color: Colors.grey.shade300, width: 1.5)),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Center(child:  Text("Update Period Info",style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorConstants.mainThemeColor),))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  periodInfoCard("Period Length", periodLength, screenSize),
                  periodInfoCard("Cycle Length", cycleLength, screenSize),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  todayDetails(
                      "Your Phase:",
                      calculateMenstrualPhase(
                              DateTime.now(), periodLength, cycleLength, lastPeriod)
                          .values
                          .elementAt(0),
                      screenSize),
                  todayDetails(
                      "Pregnancy Chance:",
                      calculateMenstrualPhase(
                              DateTime.now(), periodLength, cycleLength, lastPeriod)
                          .values
                          .elementAt(1),
                      screenSize),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget periodInfoCard(name, length, size) {
    final height = size.height;
    final width = size.width;
    String status = 'Normal';

    //some logic to calculate whether it is normal or bad
    //
    //
    if (name == 'Period Length') {
      if (length < 7 && length > 2) {
        status = 'Normal';
      } else {
        status = 'Bad';
      }
    }

    if (name == 'Cycle Length') {
      if (length < 35 && length > 21) {
        status = 'Normal';
      } else {
        status = 'Bad';
      }
    }
    return Container(
      width: width * 0.4,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
            BorderSide(color: Colors.grey.shade300, width: 1.5)),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22,
              color: status == 'Normal'
                  ? const Color.fromARGB(255, 31, 190, 123)
                  : Colors.red,
            ),
          ),
          Text(
            length.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 30,
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget todayDetails(String name, String data, size) {
    final height = size.height;
    final width = size.width;
    return Container(
      width: width * 0.4,
      height: 115,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
            BorderSide(color: Colors.grey.shade300, width: 1.5)),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: TextStyle(
                    fontSize: width * 0.04591, fontWeight: FontWeight.w400)),
            Text(data,
                style: TextStyle(
                    fontSize: width * 0.051, fontWeight: FontWeight.bold)),
          ]),
    );
  }
}
