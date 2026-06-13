import 'package:exchange_customer/core/components/app_button.dart';
import 'package:exchange_customer/core/components/app_snackbar.dart';
import 'package:exchange_customer/core/components/app_text.dart';
import 'package:exchange_customer/core/constants/colors.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_customer/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangeRequestsScreen extends StatefulWidget {
  const ExchangeRequestsScreen({super.key});

  @override
  State<ExchangeRequestsScreen> createState() => _ExchangeRequestsScreenState();
}

class _ExchangeRequestsScreenState extends State<ExchangeRequestsScreen> {
  static const _filters = <(int?, String)>[
    (null, 'الكل'),
    (0, 'معلقة'),
    (1, 'مقبولة'),
    (2, 'مرفوضة'),
    (3, 'موقوفة'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<ExchangeRequestsCubit>().fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.kBackgroundDark
          : const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.kPrimaryColorDarkMode
            : AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
        title: const AppText(
          'سجل طلبات الصرف',
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body:
          BlocConsumer<
            ExchangeRequestsCubit,
            SigninState<List<ExchangeRequestModel>>
          >(
            listenWhen: (prev, curr) =>
                prev.maybeWhen(loading: () => true, orElse: () => false),
            listener: (context, state) {
              state.maybeWhen(
                error: (msg) => AppSnackbar.showError(context, msg),
                orElse: () {},
              );
            },
            builder: (context, state) {
              final cubit = context.read<ExchangeRequestsCubit>();
              return Column(
                children: [
                  _FilterChips(filters: _filters, cubit: cubit, isDark: isDark),
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.kPrimaryColor,
                      onRefresh: () => cubit.fetchRequests(),
                      child: state.when(
                        initial: () => const SizedBox.shrink(),
                        loading: () => _buildShimmer(),
                        success: (requests) => requests.isEmpty
                            ? _buildEmpty()
                            : _buildList(requests, cubit),
                        error: (msg) => _buildError(msg, cubit),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 118,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 72,
            color: AppColors.kGreyColor.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 16),
          const AppText(
            'لا توجد طلبات صرف',
            fontSize: 16,
            color: AppColors.kGreyColor,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, ExchangeRequestsCubit cubit) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.kRedColor.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            AppText(
              message,
              fontSize: 14,
              color: AppColors.kGreyColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'إعادة المحاولة',
              icon: Icons.refresh_rounded,
              onPressed: cubit.fetchRequests,
              padding: EdgeInsets.zero,
              height: 44,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    List<ExchangeRequestModel> requests,
    ExchangeRequestsCubit cubit,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => _RequestCard(
        request: requests[index],
        onTap: () => _openDetail(context, requests[index], cubit),
      ),
    );
  }

  void _openDetail(
    BuildContext context,
    ExchangeRequestModel request,
    ExchangeRequestsCubit cubit,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _RequestDetailSheet(request: request),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER CHIPS
// ─────────────────────────────────────────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  final List<(int?, String)> filters;
  final ExchangeRequestsCubit cubit;
  final bool isDark;

  const _FilterChips({
    required this.filters,
    required this.cubit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ExchangeRequestsCubit,
      SigninState<List<ExchangeRequestModel>>
    >(
      buildWhen: (prev, curr) =>
          prev.maybeWhen(success: (_) => true, orElse: () => false),
      builder: (context, _) {
        return Container(
          color: isDark ? AppColors.kCardDark : Colors.white,
          child: SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final (value, label) = filters[index];
                final isSelected = cubit.statusFilter == value;
                return FilterChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) => cubit.setFilter(value),
                  selectedColor: AppColors.kPrimaryColor.withValues(
                    alpha: 0.15,
                  ),
                  checkmarkColor: AppColors.kPrimaryColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.kPrimaryColor
                        : AppColors.kGreyColor,
                    fontFamily: 'Cairo-Bold',
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REQUEST CARD
// ─────────────────────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final ExchangeRequestModel request;
  final VoidCallback onTap;

  const _RequestCard({required this.request, required this.onTap});

  static const _statusConfig = {
    0: (
      color: Color(0xFFF59E0B),
      label: 'معلّق',
      icon: Icons.hourglass_empty_rounded,
    ),
    1: (
      color: AppColors.kSuccessColor,
      label: 'مقبول',
      icon: Icons.check_circle_rounded,
    ),
    2: (color: AppColors.kRedColor, label: 'مرفوض', icon: Icons.cancel_rounded),
    3: (
      color: AppColors.kGreyColor,
      label: 'موقوف',
      icon: Icons.pause_circle_rounded,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cfg =
        _statusConfig[request.status] ??
        (
          color: AppColors.kGreyColor,
          label: '—',
          icon: Icons.help_outline_rounded,
        );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.kCardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
          border: Border(left: BorderSide(color: cfg.color, width: 4)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        request.user?.fullName ?? '—',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      if (request.requestNumber != null)
                        AppText(
                          '#${request.requestNumber}',
                          fontSize: 11,
                          color: AppColors.kGreyColor,
                          fontWeight: FontWeight.w400,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cfg.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(cfg.icon, size: 12, color: cfg.color),
                      const SizedBox(width: 4),
                      AppText(cfg.label, fontSize: 12, color: cfg.color),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'من',
                        fontSize: 10,
                        color: AppColors.kGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                      Row(
                        children: [
                          AppText(
                            _fmt(request.amount),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kRedColor,
                          ),
                          const SizedBox(width: 4),
                          AppText(
                            request.fromCurrency?.code ?? '—',
                            fontSize: 11,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.swap_horiz_rounded,
                    color: AppColors.kPrimaryColor,
                    size: 22,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        'إلى',
                        fontSize: 10,
                        color: AppColors.kGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                      Row(
                        children: [
                          AppText(
                            _fmt(request.finalAmount),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kSuccessColor,
                          ),
                          const SizedBox(width: 4),
                          AppText(
                            request.toCurrency?.code ?? '—',
                            fontSize: 11,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 11,
                  color: AppColors.kGreyColor,
                ),
                const SizedBox(width: 4),
                AppText(
                  _fmtDate(request.createdAt ?? request.createdOn),
                  fontSize: 11,
                  color: AppColors.kGreyColor,
                  fontWeight: FontWeight.w400,
                ),
                const Spacer(),
                if (request.status == 0) ...[
                  Icon(
                    Icons.touch_app_rounded,
                    size: 13,
                    color: AppColors.kPrimaryColor.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 3),
                  AppText(
                    'اضغط لاتخاذ إجراء',
                    fontSize: 11,
                    color: AppColors.kPrimaryColor.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double? v) {
    if (v == null) return '—';
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}م';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}ك';
    return v.toStringAsFixed(0);
  }

  String _fmtDate(String? d) {
    if (d == null) return '—';
    try {
      final dt = DateTime.parse(d);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return d;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REQUEST DETAIL BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _RequestDetailSheet extends StatelessWidget {
  final ExchangeRequestModel request;

  const _RequestDetailSheet({required this.request});

  static const _statusConfig = {
    0: (color: Color(0xFFF59E0B), label: 'معلّق'),
    1: (color: AppColors.kSuccessColor, label: 'مقبول'),
    2: (color: AppColors.kRedColor, label: 'مرفوض'),
    3: (color: AppColors.kGreyColor, label: 'موقوف'),
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cfg =
        _statusConfig[request.status] ??
        (color: AppColors.kGreyColor, label: '—');
    final cubit = context.read<ExchangeRequestsCubit>();

    return BlocListener<
      ExchangeRequestsCubit,
      SigninState<List<ExchangeRequestModel>>
    >(
      listenWhen: (prev, curr) =>
          prev.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            AppSnackbar.showSuccess(context, 'تم تحديث حالة الطلب بنجاح');
            Navigator.pop(context);
          },
          error: (msg) => AppSnackbar.showError(context, msg),
          orElse: () {},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.kCardDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.kGreyColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const AppText(
                  'تفاصيل الطلب',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: cfg.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AppText(cfg.label, fontSize: 13, color: cfg.color),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.person_outline_rounded,
              label: 'الطالب',
              value: request.user?.fullName ?? '—',
            ),
            if (request.requestNumber != null)
              _DetailRow(
                icon: Icons.tag_rounded,
                label: 'رقم الطلب',
                value: '#${request.requestNumber}',
              ),
            _DetailRow(
              icon: Icons.calendar_today_rounded,
              label: 'التاريخ',
              value: _fmtDate(request.createdAt ?? request.createdOn),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'من',
                            fontSize: 11,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.w400,
                          ),
                          AppText(
                            '${_fmt(request.amount)} ${request.fromCurrency?.code ?? ''}',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kRedColor,
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.swap_horiz_rounded,
                        color: AppColors.kPrimaryColor,
                        size: 28,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppText(
                            'إلى',
                            fontSize: 11,
                            color: AppColors.kGreyColor,
                            fontWeight: FontWeight.w400,
                          ),
                          AppText(
                            '${_fmt(request.finalAmount)} ${request.toCurrency?.code ?? ''}',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kSuccessColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (request.appliedRate != null ||
                      request.commissionPercent != null) ...[
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: AppColors.kGreyColor.withValues(alpha: 0.15),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (request.appliedRate != null)
                          _MiniStat(
                            label: 'سعر الصرف',
                            value: request.appliedRate!.toStringAsFixed(4),
                          ),
                        if (request.commissionPercent != null)
                          _MiniStat(
                            label: 'العمولة',
                            value: '${request.commissionPercent}%',
                          ),
                        if (request.commissionAmount != null)
                          _MiniStat(
                            label: 'مبلغ العمولة',
                            value: _fmt(request.commissionAmount),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (request.notes != null && request.notes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _DetailRow(
                icon: Icons.notes_rounded,
                label: 'ملاحظات',
                value: request.notes!,
              ),
            ],
            if (request.status == 0) ...[
              const SizedBox(height: 20),
              const AppText(
                'اتخاذ إجراء',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 10),
              BlocBuilder<
                ExchangeRequestsCubit,
                SigninState<List<ExchangeRequestModel>>
              >(
                builder: (context, state) {
                  final isLoading = state.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );
                  return Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: 'قبول',
                          icon: Icons.check_circle_outline_rounded,
                          color: AppColors.kSuccessColor,
                          isLoading: isLoading,
                          onTap: () => _confirmAction(
                            context,
                            'قبول',
                            AppColors.kSuccessColor,
                            () => cubit.updateRequest(
                              request.id!,
                              const ExchangeRequestRequestModel(newStatus: 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionButton(
                          label: 'رفض',
                          icon: Icons.cancel_outlined,
                          color: AppColors.kRedColor,
                          isLoading: isLoading,
                          onTap: () => _confirmAction(
                            context,
                            'رفض',
                            AppColors.kRedColor,
                            () => cubit.updateRequest(
                              request.id!,
                              const ExchangeRequestRequestModel(
                                newStatus: 5,
                                note: "ما معي رصيد",
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionButton(
                          label: 'تعليق',
                          icon: Icons.pause_circle_outline_rounded,
                          color: AppColors.kWarningColor,
                          isLoading: isLoading,
                          onTap: () => _confirmAction(
                            context,
                            'تعليق',
                            AppColors.kWarningColor,
                            () => cubit.updateRequest(
                              request.id!,
                              const ExchangeRequestRequestModel(
                                newStatus: 0,
                                note: 'تم تعليق الطلب مؤقتًا',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmAction(
    BuildContext context,
    String actionLabel,
    Color color,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const AppText('تأكيد الإجراء', fontWeight: FontWeight.w700),
        content: AppText('هل تريد $actionLabel هذا الطلب؟', maxLines: 2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: const AppText('إلغاء', color: AppColors.kGreyColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dlgCtx);
              onConfirm();
            },
            child: AppText(actionLabel, color: color),
          ),
        ],
      ),
    );
  }

  String _fmt(double? v) {
    if (v == null) return '—';
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}م';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}ك';
    return v.toStringAsFixed(0);
  }

  String _fmtDate(String? d) {
    if (d == null) return '—';
    try {
      final dt = DateTime.parse(d);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return d;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED HELPER WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.kGreyColor),
          const SizedBox(width: 8),
          AppText(
            label,
            fontSize: 12,
            color: AppColors.kGreyColor,
            fontWeight: FontWeight.w400,
          ),
          const Spacer(),
          AppText(
            value,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          label,
          fontSize: 10,
          color: AppColors.kGreyColor,
          fontWeight: FontWeight.w400,
        ),
        AppText(value, fontSize: 13, fontWeight: FontWeight.w700),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(color: color, strokeWidth: 2),
              )
            else
              Icon(icon, size: 16, color: color),
            const SizedBox(width: 5),
            AppText(label, fontSize: 13, color: color),
          ],
        ),
      ),
    );
  }
}
