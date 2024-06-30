import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API{
  final Dio _dio = Dio();

  API(){
    _dio.options.baseUrl="https://googlexyugxbackend-uplniytx2q-el.a.run.app";
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get sendRequest => _dio;

}