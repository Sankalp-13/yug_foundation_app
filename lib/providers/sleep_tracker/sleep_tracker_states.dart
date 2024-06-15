import '../../domain/models/user_sleep_model.dart';

abstract class SleepTrackerState {}

class SleepTrackerLoadingState extends SleepTrackerState {}

class SleepTrackerSleepingState extends SleepTrackerState {
  DateTime sleptAt;
  SleepTrackerSleepingState(this.sleptAt);
}

class SleepTrackerLoadedState extends SleepTrackerState {
  final UserSleep userSleep;

  SleepTrackerLoadedState(this.userSleep);
}

class SleepTrackerErrorState extends SleepTrackerState {
  final String error;

  SleepTrackerErrorState(this.error);
}
