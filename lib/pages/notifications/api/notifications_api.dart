// import 'package:exchange_customer/core/constants/base_api.dart';
// import 'package:exchange_customer/core/networking/api_result.dart';
// import 'package:exchange_customer/pages/notifications/api/notifications_api_service.dart';
// import 'package:exchange_customer/pages/notifications/model/notification_model.dart';

// class NotificationsApi extends BaseApi {
//   final NotificationsApiService _service;

//   NotificationsApi(this._service);

//   Future<ApiResult<List<NotificationModel>>> getNotifications() =>
//       execute(request: () => _service.getNotifications());

//   Future<ApiResult<bool>> markAsRead(String id) => execute(
//         request: () async {
//           await _service.markAsRead(id);
//           return true;
//         },
//       );

//   Future<ApiResult<bool>> markAllAsRead() => execute(
//         request: () async {
//           await _service.markAllAsRead();
//           return true;
//         },
//       );
// }
