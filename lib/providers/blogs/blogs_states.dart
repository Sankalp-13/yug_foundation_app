import 'package:yug_foundation_app/domain/models/blogs_response_model.dart';

abstract class BlogsState {}

class BlogsLoadingState extends BlogsState {}

class BlogsLoadedState extends BlogsState {
  final BlogsResponseModel response;

  BlogsLoadedState(this.response);
}

class BlogsErrorState extends BlogsState {
  final String error;

  BlogsErrorState(this.error);
}
