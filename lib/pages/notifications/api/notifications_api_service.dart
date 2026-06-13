// import 'package:dio/dio.dart';
// import 'package:exchange_customer/core/networking/api_constans.dart';
// import 'package:exchange_customer/pages/notifications/model/notification_model.dart';

// class NotificationsApiService {
//   final Dio _dio;

//   NotificationsApiService(this._dio);

//   Future<List<NotificationModel>> getNotifications() async {
//     final response = await _dio.get(ApiConstants.notifications);
//     return _parseList(response.data, NotificationModel.fromJson);
//   }

//   Future<void> markAsRead(String id) async {
//     await _dio.put('${ApiConstants.notificationMarkAsRead}/$id');
//   }

//   Future<void> markAllAsRead() async {
//     await _dio.put(ApiConstants.notificationMarkAllAsRead);
//   }

//   static List<T> _parseList<T>(
//     dynamic data,
//     T Function(Map<String, dynamic>) fromJson,
//   ) {
//     if (data is List) {
//       return data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
//     }
//     if (data is Map<String, dynamic>) {
//       if (data['succeeded'] == false) {
//         throw Exception(
//           (data['error'] as Map<String, dynamic>?)?['message'] ??
//               'فشل تحميل البيانات',
//         );
//       }
//       final list = data['data'];
//       if (list is List) {
//         return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
//       }
//     }
//     return [];
//   }
// }
