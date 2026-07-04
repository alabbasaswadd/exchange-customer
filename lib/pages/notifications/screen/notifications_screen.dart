import 'package:exchange_customer/core/components/app_text.dart';
import 'package:exchange_customer/core/constants/colors.dart';
import 'package:exchange_customer/pages/notifications/cubit/notifications_cubit.dart';
import 'package:exchange_customer/pages/notifications/cubit/notifications_state.dart';
import 'package:exchange_customer/pages/notifications/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.kBackgroundDark
          : AppColors.kBackgroundLight,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.kPrimaryColorDarkMode
            : AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
        title: const AppText('الإشعارات', color: Colors.white, fontSize: 17),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            unreadCountLoaded: (_) => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (notifications) {
              if (notifications.isEmpty) return _buildEmpty();
              return RefreshIndicator(
                color: AppColors.kPrimaryColor,
                onRefresh: () =>
                    context.read<NotificationsCubit>().fetchNotifications(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _NotificationTile(
                    notification: notifications[i],
                    onTap: () {},
                  ),
                ),
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.kRedColor,
                  ),
                  const SizedBox(height: 12),
                  AppText(
                    message,
                    fontSize: 14,
                    color: AppColors.kGreyColor,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<NotificationsCubit>().fetchNotifications(),
                    child: const AppText('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 72,
            color: AppColors.kGreyColor.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 16),
          const AppText(
            'لا توجد إشعارات',
            fontSize: 16,
            color: AppColors.kGreyColor,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  Color get _typeColor {
    switch (notification.notificationType) {
      case 1:
        return AppColors.kSuccessColor;
      case 2:
        return AppColors.kWarningColor;
      case 3:
        return AppColors.kRedColor;
      default:
        return const Color(0xFF3B82F6);
    }
  }

  IconData get _typeIcon {
    switch (notification.notificationType) {
      case 1:
        return Icons.check_circle_rounded;
      case 2:
        return Icons.warning_rounded;
      case 3:
        return Icons.error_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String get _typeLabel {
    switch (notification.notificationType) {
      case 1:
        return 'نجاح';
      case 2:
        return 'تحذير';
      case 3:
        return 'خطأ';
      default:
        return 'معلومة';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRead = notification.isRead ?? false;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isDark ? AppColors.kCardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            right: BorderSide(
              color: isRead ? Colors.transparent : _typeColor,
              width: 4,
            ),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: isRead
                    ? Colors.black.withValues(alpha: 0.04)
                    : _typeColor.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _typeColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_typeIcon, color: _typeColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AppText(
                          _typeLabel,
                          fontSize: 10,
                          color: _typeColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _typeColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    notification.title ?? '',
                    fontSize: 14,
                    fontWeight: isRead ? FontWeight.w400 : FontWeight.w700,
                    maxLines: 1,
                  ),
                  if (notification.body != null) ...[
                    const SizedBox(height: 4),
                    AppText(
                      notification.body!,
                      fontSize: 12,
                      color: AppColors.kGreyColor,
                      fontWeight: FontWeight.w400,
                      maxLines: 3,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: AppColors.kGreyColor.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      AppText(
                        notification.createdOn ?? '',
                        fontSize: 11,
                        color: AppColors.kGreyColor.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w400,
                      ),
                      if (!isRead) ...[
                        const Spacer(),
                        AppText(
                          'اضغط للتحديد كمقروء',
                          fontSize: 10,
                          color: _typeColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
