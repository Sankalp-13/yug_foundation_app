import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yug_foundation_app/domain/models/user_sleep_model.dart';
import 'package:yug_foundation_app/providers/sleep_tracker/sleep_tracker_states.dart';

class SleepTrackerCubit extends Cubit<SleepTrackerState> {
  SleepTrackerCubit() : super(SleepTrackerLoadingState());
  final storage = const FlutterSecureStorage();

  void getSleepData() async {
    emit(SleepTrackerLoadingState());
    UserSleep sleepTracker =
        UserSleep.fromJson(jsonDecode((await storage.read(key: "sleepData"))!));
    if (sleepTracker.sleptAt != null) {
      int diff = DateTime.now().difference(sleepTracker.sleptAt!).inMinutes;
      sleepTracker.days[sleepTracker.sleptAt!.weekday-1] = diff / 60;
      sleepTracker.sleptAt = null;
      await storage.write(
          key: 'sleepData', value: jsonEncode(sleepTracker.toJson()));
    }
    emit(SleepTrackerLoadedState(sleepTracker));
  }

  void goToSleep(DateTime dateTime) async {
    UserSleep sleepTracker =
        UserSleep.fromJson(jsonDecode(await storage.read(key: "sleepData") ?? '{}'));
    sleepTracker.sleptAt = dateTime;
    await storage.write(
        key: 'sleepData', value: jsonEncode(sleepTracker.toJson()));
    emit(SleepTrackerSleepingState(dateTime));
  }

  void cancelSleep() async {
    UserSleep sleepTracker =
    UserSleep.fromJson(jsonDecode(await storage.read(key: "sleepData") ?? '{}'));
    sleepTracker.sleptAt = null;
    await storage.write(
        key: 'sleepData', value: jsonEncode(sleepTracker.toJson()));
    emit(SleepTrackerLoadedState(sleepTracker));
  }

  void checkIfAsleep() async {
    UserSleep sleepTracker =
        UserSleep.fromJson(jsonDecode(await storage.read(key: "sleepData") ?? '{}'));
    if (sleepTracker.sleptAt != null) {
      emit(SleepTrackerSleepingState(sleepTracker.sleptAt!));
    } else {
      emit(SleepTrackerLoadedState(sleepTracker));
    }
  }
}
