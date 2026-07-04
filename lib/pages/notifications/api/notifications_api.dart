import 'package:exchange_customer/core/constants/base_api.dart';
import 'package:exchange_customer/core/networking/api_result.dart';
import 'package:exchange_customer/pages/notifications/api/notifications_api_service.dart';
import 'package:exchange_customer/pages/notifications/model/notification_model.dart';

class NotificationsApi extends BaseApi {
  final NotificationsApiService _service;

  NotificationsApi(this._service);

  Future<ApiResult<List<NotificationModel>>> getNotifications() =>
      execute(request: () async {
        final response = await _service.getNotifications();
        return response.data?.items ?? [];
      });

  Future<ApiResult<int>> getUnreadCount() => execute(
        request: () async {
          final response = await _service.getUnreadCount();
          return response.data ?? 0;
        },
      );
}
