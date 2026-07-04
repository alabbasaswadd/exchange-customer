import 'package:exchange_customer/pages/notifications/model/notification_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_state.freezed.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = _Initial;
  const factory NotificationsState.loading() = _Loading;
  const factory NotificationsState.success(
    List<NotificationModel> notifications,
  ) = _Success;
  const factory NotificationsState.error(String message) = _Error;
  const factory NotificationsState.unreadCountLoaded(int count) =
      _UnreadCountLoaded;
}
