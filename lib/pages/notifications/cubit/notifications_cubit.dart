import 'package:exchange_customer/core/constants/base_cubit.dart';
import 'package:exchange_customer/pages/notifications/api/notifications_api.dart';
import 'package:exchange_customer/pages/notifications/cubit/notifications_state.dart';
import 'package:exchange_customer/pages/notifications/model/notification_model.dart';

class NotificationsCubit extends BaseCubit<NotificationsState> {
  final NotificationsApi _api;
  List<NotificationModel> _notifications = [];

  NotificationsCubit(this._api) : super(const NotificationsState.initial());

  int get unreadCount => state.maybeWhen(
        success: (notifications) =>
            notifications.where((n) => n.isRead != true).length,
        unreadCountLoaded: (count) => count,
        orElse: () => 0,
      );

  Future<void> fetchNotifications() async {
    await executeApi(
      onLoading: () => emit(const NotificationsState.loading()),
      request: () => _api.getNotifications(),
      onSuccess: (notifications) async {
        _notifications = notifications;
        emit(NotificationsState.success(_notifications));
      },
      onError: (message) => emit(NotificationsState.error(message)),
    );
  }

  Future<void> fetchUnreadCount() async {
    await executeApi(
      onLoading: () {},
      request: () => _api.getUnreadCount(),
      onSuccess: (count) async =>
          emit(NotificationsState.unreadCountLoaded(count)),
      onError: (_) {},
    );
  }
}
