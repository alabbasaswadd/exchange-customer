import 'package:dio/dio.dart';

import '../networking/api_error_handler.dart';
import '../networking/api_result.dart';
import 'model/error_model.dart';

abstract class BaseApi {
  Future<ApiResult<T>> execute<T>({
    required Future<T> Function() request,
  }) async {
    try {
      final response = await request();
      return ApiResult.success(response);
    } on DioException catch (e) {
      final serverMessage =
          _extractErrorMessage(e) ?? ErrorHandler.handle(e).errorModel.message;
      return ApiResult.failure(
        ErrorModel(message: serverMessage, errors: {}),
      );
    } catch (e) {
      return ApiResult.failure(ErrorModel(message: e.toString(), errors: {}));
    }
  }

  String? _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is! Map<String, dynamic>) return null;
    final msg = data['message'] as String?;
    if (msg != null && msg.isNotEmpty) return msg;
    final errors = data['errors'];
    if (errors is Map<String, dynamic>) {
      final messages = errors.values
          .expand(
            (v) => v is List
                ? v.map((item) => item.toString())
                : [v.toString()],
          )
          .where((s) => s.isNotEmpty)
          .toList();
      if (messages.isNotEmpty) return messages.join('\n');
    }
    return null;
  }
}
