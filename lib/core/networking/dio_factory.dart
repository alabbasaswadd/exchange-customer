import 'package:dio/dio.dart';
import 'package:exchange_customer/core/constants/functions.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constans.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    if (dio == null) {
      const timeOut = Duration(seconds: 30);
      dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.apiBaseUrl,
          connectTimeout: timeOut,
          receiveTimeout: timeOut,
        ),
      );
      _addAuthInterceptor();
      addDioInterceptor();
    }
    return dio!;
  }

  static void _addAuthInterceptor() {
    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = UserSession.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
}
