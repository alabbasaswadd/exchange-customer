import 'package:exchange_customer/core/constants/cached/cached_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _saveToken();
  }

  static Future<void> _requestPermission() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  static Future<void> _saveToken() async {
    final token = await _messaging.getToken();
    if (token != null) await CacheHelper.setString('fcm_token', token);

    _messaging.onTokenRefresh.listen(
      (newToken) => CacheHelper.setString('fcm_token', newToken),
    );
  }

  static Future<String?> getToken() async {
    final cached = await CacheHelper.getString('fcm_token');
    return cached.isEmpty ? null : cached;
  }
}
