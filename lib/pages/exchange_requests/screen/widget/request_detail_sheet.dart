import 'dart:async';

import 'package:exchange_customer/core/components/app_snackbar.dart';
import 'package:exchange_customer/core/components/app_text.dart';
import 'package:exchange_customer/core/constants/colors.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_customer/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STATUS CONFIG  (shared between card + sheet)
// ─────────────────────────────────────────────────────────────────────────────

typedef _StatusCfg = ({Color color, String label, IconData icon});

const Map<int, _StatusCfg> kExchangeStatusConfig = {
  0: (
    color: Color(0xFFF59E0B),
    label: 'بانتظار مراجعة الصراف',
    icon: Icons.hourglass_empty_rounded,
  ),
  1: (
    color: Color(0xFF3B82F6),
    label: 'بانتظار تحويل المبلغ',
    icon: Icons.payment_rounded,
  ),
  2: (
    color: AppColors.kSuccessColor,
    label: 'تم استلام المبلغ',
    icon: Icons.check_circle_rounded,
  ),
  3: (
    color: Color(0xFF8B5CF6),
    label: 'جاري التنفيذ',
    icon: Icons.autorenew_rounded,
  ),
  4: (
    color: AppColors.kSuccessColor,
    label: 'تمت العملية بنجاح',
    icon: Icons.task_alt_rounded,
  ),
  5: (
    color: AppColors.kRedColor,
    label: 'تم رفض الطلب',
    icon: Icons.cancel_rounded,
  ),
  6: (
    color: AppColors.kGreyColor,
    label: 'انتهت صلاحية الطلب',
    icon: Icons.timer_off_rounded,
  ),
  7: (
    color: AppColors.kGreyColor,
    label: 'تم إلغاء الطلب',
    icon: Icons.block_rounded,
  ),
};

// ─────────────────────────────────────────────────────────────────────────────
// REQUEST DETAIL BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class RequestDetailSheet extends StatelessWidget {
  final ExchangeRequestModel request;

  const RequestDetailSheet({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cfg = kExchangeStatusConfig[request.status] ??
        (
          color: AppColors.kGreyColor,
          label: '—',
          icon: Icons.help_outline_rounded,
        );
    final cubit = context.read<ExchangeRequestsCubit>();

    return BlocListener<ExchangeRequestsCubit,
        SigninState<List<ExchangeRequestModel>>>(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── handle ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.kGreyColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            // ── status header card ───────────────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cfg.color.withValues(alpha: 0.14),
                    cfg.color.withValues(alpha: 0.04),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cfg.color.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cfg.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cfg.icon, color: cfg.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          'تفاصيل الطلب',
                          fontSize: 15,
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
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: cfg.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cfg.icon, size: 13, color: cfg.color),
                        const SizedBox(width: 4),
                        AppText(
                          cfg.label,
                          fontSize: 11,
                          color: cfg.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ── scrollable body ──────────────────────────────────────────────
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'التاريخ',
                    value: _fmtDateTime(request.createdAt ?? request.createdOn),
                  ),
                  const SizedBox(height: 14),
                  // ── exchange amounts ───────────────────────────────────────
                  _AmountsBlock(request: request),
                  if (request.notes != null &&
                      request.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.notes_rounded,
                      label: 'ملاحظات',
                      value: request.notes!,
                    ),
                  ],
                  // ── customer actions ───────────────────────────────────────
                  if (request.status == 0) ...[
                    const SizedBox(height: 20),
                    _SectionTitle(
                      label: 'إجراءات متاحة',
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<ExchangeRequestsCubit,
                        SigninState<List<ExchangeRequestModel>>>(
                      builder: (context, state) {
                        final isLoading = state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                        return _ActionButton(
                          label: 'إلغاء الطلب',
                          icon: Icons.cancel_outlined,
                          color: AppColors.kRedColor,
                          isLoading: isLoading,
                          onTap: () => _confirmCancel(context, cubit),
                        );
                      },
                    ),
                  ],
                  if (request.status == 1) ...[
                    const SizedBox(height: 20),
                    _SectionTitle(
                      label: 'أرسل المبلغ قبل انتهاء الوقت',
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(height: 12),
                    _CountdownBanner(
                      paymentDeadline: request.paymentDeadline,
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<ExchangeRequestsCubit,
                        SigninState<List<ExchangeRequestModel>>>(
                      builder: (context, state) {
                        final isLoading = state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                        return _ActionButton(
                          label: 'تأكيد إرسال المبلغ',
                          icon: Icons.send_rounded,
                          color: AppColors.kSuccessColor,
                          isLoading: isLoading,
                          onTap: () => _confirmPayment(context, cubit),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmCancel(
      BuildContext context, ExchangeRequestsCubit cubit) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const AppText('إلغاء الطلب', fontWeight: FontWeight.w700),
        content: const AppText(
          'هل أنت متأكد من إلغاء هذا الطلب؟ لا يمكن التراجع عن هذا الإجراء.',
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: const AppText('تراجع', color: AppColors.kGreyColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dlgCtx);
              cubit.cancelRequest(request.id!);
            },
            child: const AppText('إلغاء الطلب',
                color: AppColors.kRedColor),
          ),
        ],
      ),
    );
  }

  void _confirmPayment(
      BuildContext context, ExchangeRequestsCubit cubit) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:
            const AppText('تأكيد الإرسال', fontWeight: FontWeight.w700),
        content: AppText(
          'هل قمت بإرسال المبلغ ${_fmt(request.amount)} ${request.fromCurrency?.code ?? ''}؟',
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: const AppText('لا', color: AppColors.kGreyColor),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dlgCtx);
              cubit.confirmPayment(request.id!);
            },
            child: const AppText('نعم، أرسلت المبلغ',
                color: AppColors.kSuccessColor),
          ),
        ],
      ),
    );
  }

  String _fmt(double? v) {
    if (v == null) return '—';
    final isWhole = v == v.truncateToDouble();
    final raw =
        isWhole ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
    final parts = raw.split('.');
    final intWithCommas = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return parts.length > 1
        ? '$intWithCommas.${parts[1]}'
        : intWithCommas;
  }

  String _fmtDateTime(String? d) {
    if (d == null) return '—';
    try {
      final dt = DateTime.parse(d).toLocal();
      final date =
          '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$date  •  $hour:$minute';
    } catch (_) {
      return d;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COUNTDOWN BANNER  (StatefulWidget — ticks every second)
// ─────────────────────────────────────────────────────────────────────────────

class _CountdownBanner extends StatefulWidget {
  final String? paymentDeadline;

  const _CountdownBanner({this.paymentDeadline});

  @override
  State<_CountdownBanner> createState() => _CountdownBannerState();
}

class _CountdownBannerState extends State<_CountdownBanner> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _expired = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    DateTime? deadline;
    if (widget.paymentDeadline != null) {
      try {
        deadline = DateTime.parse(widget.paymentDeadline!).toLocal();
      } catch (_) {}
    }
    deadline ??= DateTime.now().add(const Duration(minutes: 5));

    final now = DateTime.now();
    final diff = deadline.difference(now);
    if (diff.isNegative) {
      _expired = true;
      _remaining = Duration.zero;
      return;
    }
    _remaining = diff;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = deadline!.difference(DateTime.now());
      if (left.isNegative) {
        setState(() {
          _expired = true;
          _remaining = Duration.zero;
        });
        _timer?.cancel();
      } else {
        setState(() => _remaining = left);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _expired
        ? AppColors.kRedColor
        : _remaining.inSeconds < 60
            ? AppColors.kRedColor
            : const Color(0xFF3B82F6);

    final minutes =
        _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: _expired
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer_off_rounded, color: AppColors.kRedColor,
                    size: 20),
                const SizedBox(width: 8),
                const AppText(
                  'انتهى وقت الإرسال',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kRedColor,
                ),
              ],
            )
          : Column(
              children: [
                AppText(
                  '$minutes:$seconds',
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                const SizedBox(height: 4),
                AppText(
                  'الوقت المتبقي لإرسال المبلغ',
                  fontSize: 12,
                  color: color.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AMOUNTS BLOCK
// ─────────────────────────────────────────────────────────────────────────────

class _AmountsBlock extends StatelessWidget {
  final ExchangeRequestModel request;

  const _AmountsBlock({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kPrimaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.kPrimaryColor.withValues(alpha: 0.09),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'المبلغ المُرسَل',
                      fontSize: 10,
                      color: AppColors.kGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText(
                          _fmt(request.amount),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kRedColor,
                        ),
                        if (request.fromCurrency?.code != null) ...[
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: AppText(
                              request.fromCurrency!.code!,
                              fontSize: 12,
                              color: AppColors.kRedColor.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (request.fromCurrency?.name != null)
                      AppText(
                        request.fromCurrency!.name!,
                        fontSize: 11,
                        color: AppColors.kGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.trending_flat_rounded,
                  color: AppColors.kPrimaryColor,
                  size: 20,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const AppText(
                      'المبلغ المُستلَم',
                      fontSize: 10,
                      color: AppColors.kGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText(
                          _fmt(request.finalAmount),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kSuccessColor,
                        ),
                        if (request.toCurrency?.code != null) ...[
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: AppText(
                              request.toCurrency!.code!,
                              fontSize: 12,
                              color: AppColors.kSuccessColor
                                  .withValues(alpha: 0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (request.toCurrency?.name != null)
                      AppText(
                        request.toCurrency!.name!,
                        fontSize: 11,
                        color: AppColors.kGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (request.appliedRate != null ||
              request.commissionPercent != null) ...[
            const SizedBox(height: 14),
            Divider(
              height: 1,
              color: AppColors.kGreyColor.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (request.appliedRate != null)
                  _MiniStat(
                    label: 'سعر الصرف',
                    value: _fmtRate(request.appliedRate!),
                  ),
                if (request.commissionPercent != null)
                  _MiniStat(
                    label: 'العمولة %',
                    value: '${_fmt(request.commissionPercent)}%',
                  ),
                if (request.commissionAmount != null)
                  _MiniStat(
                    label: 'مبلغ العمولة',
                    value:
                        '${_fmt(request.commissionAmount)} ${request.fromCurrency?.code ?? ''}',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(double? v) {
    if (v == null) return '—';
    final isWhole = v == v.truncateToDouble();
    final raw =
        isWhole ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
    final parts = raw.split('.');
    final intWithCommas = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return parts.length > 1
        ? '$intWithCommas.${parts[1]}'
        : intWithCommas;
  }

  String _fmtRate(double v) {
    final s = v.toStringAsFixed(4);
    final parts = s.split('.');
    final intWithCommas = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$intWithCommas.${parts[1]}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String label;
  final Color color;

  const _SectionTitle({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        AppText(label, fontSize: 14, fontWeight: FontWeight.w700),
      ],
    );
  }
}

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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
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
                child: CircularProgressIndicator(
                    color: color, strokeWidth: 2),
              )
            else
              Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            AppText(
              label,
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
