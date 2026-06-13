import 'package:bloc/bloc.dart';
import 'package:exchange_customer/pages/notifications/model/notification_model.dart';

class NotificationsCubit extends Cubit<List<NotificationModel>> {
  NotificationsCubit() : super([]) {
    _load();
  }

  void _load() => emit(List.from(_mock));

  void markAsRead(String id) {
    emit(state.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList());
  }

  void markAllAsRead() {
    emit(state.map((n) => n.copyWith(isRead: true)).toList());
  }

  int get unreadCount => state.where((n) => n.isRead == false).length;

  static final List<NotificationModel> _mock = [
    NotificationModel(
      id: '1',
      title: 'طلب صرف جديد',
      body: 'أحمد محمد قدّم طلب صرف 500 دولار إلى ليرة سورية',
      isRead: false,
      type: 'info',
      createdAt: 'منذ 5 دقائق',
    ),
    NotificationModel(
      id: '2',
      title: 'تم قبول الطلب',
      body: 'تم قبول طلب الصرف #2 بنجاح',
      isRead: false,
      type: 'success',
      createdAt: 'منذ 20 دقيقة',
    ),
    NotificationModel(
      id: '3',
      title: 'تحذير: طلب معلق',
      body: 'طلب نور الدين مصطفى لا يزال معلقاً منذ ساعتين',
      isRead: false,
      type: 'warning',
      createdAt: 'منذ ساعتين',
    ),
    NotificationModel(
      id: '4',
      title: 'تم رفض الطلب',
      body: 'تم رفض طلب سارة يوسف بسبب وثائق غير مكتملة',
      isRead: true,
      type: 'error',
      createdAt: 'أمس',
    ),
    NotificationModel(
      id: '5',
      title: 'تحديث أسعار الصرف',
      body: 'تم تحديث سعر صرف الدولار مقابل الليرة السورية',
      isRead: true,
      type: 'info',
      createdAt: 'أمس',
    ),
  ];
}
