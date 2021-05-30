import 'package:dio/dio.dart';

class Static {
  Static._();

  static const url = 'http://45.90.34.23:8004/api/v1/';

  static Dio dio({String newUrl}) {
    final baseClient = Dio(
      BaseOptions(
        baseUrl: newUrl ?? url,
      ),
    );
    baseClient.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
    return baseClient;
  }
}
