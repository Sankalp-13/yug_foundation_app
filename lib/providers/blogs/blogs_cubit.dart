import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yug_foundation_app/domain/models/blogs_response_model.dart';
import 'package:yug_foundation_app/domain/repository/blogs_repo.dart';
import 'package:yug_foundation_app/providers/blogs/blogs_states.dart';

class BlogsCubit extends Cubit<BlogsState>{
  BlogsCubit(): super(BlogsLoadingState());
  final storage = const FlutterSecureStorage();
   BlogsRepo blogsRepo = BlogsRepo();

  void getBlogs() async{
    try{
      emit(BlogsLoadingState());
      String? token = await storage.read(key: "accessToken");
      BlogsResponseModel blogs = await blogsRepo.getBlogs(token!);
      emit(BlogsLoadedState(blogs));
    }on DioException catch(ex){
      if(ex.type == DioExceptionType.badResponse) {
        emit(BlogsErrorState("Something went wrong"));
      }else if(ex.type == DioExceptionType.unknown||ex.type == DioExceptionType.connectionError||ex.type == DioExceptionType.connectionTimeout){
        emit(BlogsErrorState("Can't connect to server!"));
      }else{
        emit(BlogsErrorState(ex.type.toString()));
      }
    }
  }

}