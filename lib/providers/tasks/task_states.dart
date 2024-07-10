import 'package:yug_foundation_app/domain/models/task_response_model.dart';


abstract class TasksState {}

class TasksLoadingState extends TasksState {}


class TasksLoadedState extends TasksState {
  final TasksResponseModel response;

  TasksLoadedState(this.response);
}

class TasksErrorState extends TasksState {
  final String error;

  TasksErrorState(this.error);
}
