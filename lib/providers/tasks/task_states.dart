import '../../domain/models/survey_response_model.dart';

abstract class TasksState {}

class TasksLoadingState extends TasksState {}


class TasksLoadedState extends TasksState {
  // final List<SurveyResponseModel> response;
  //
  // TasksLoadedState(this.response);
}

class TasksErrorState extends TasksState {
  final String error;

  TasksErrorState(this.error);
}
