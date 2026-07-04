import 'package:dio/dio.dart';
import 'package:exchange_customer/core/networking/api_constans.dart';
import 'package:exchange_customer/pages/notifications/model/notification_list_response_model.dart';
import 'package:exchange_customer/pages/notifications/model/unread_count_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'notifications_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class NotificationsApiService {
  factory NotificationsApiService(Dio dio, {String baseUrl}) =
      _NotificationsApiService;

  @GET(ApiConstants.allNotifications)
  Future<NotificationListResponseModel> getNotifications();

  @GET(ApiConstants.unreadNotifications)
  Future<UnreadCountResponseModel> getUnreadCount();
}
