import 'package:exchange_customer/core/components/app_button.dart';
import 'package:exchange_customer/core/components/app_snackbar.dart';
import 'package:exchange_customer/core/components/app_text.dart';
import 'package:exchange_customer/core/constants/colors.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_customer/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/screen/widget/request_detail_sheet.dart';
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
    (1, 'بانتظار الدفع'),
    (4, 'مكتملة'),
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
                  _FilterBar(filters: _filters, cubit: cubit, isDark: isDark),
                  // _SummarySection(cubit: cubit, isDark: isDark),
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
        child: RequestDetailSheet(request: request),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER BAR
// ─────────────────────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final List<(int?, String)> filters;
  final ExchangeRequestsCubit cubit;
  final bool isDark;

  const _FilterBar({
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
        final activeColor = isDark ? Colors.white : AppColors.kPrimaryColor;
        return Container(
          color: isDark ? AppColors.kCardDark : Colors.white,
          child: Row(
            children: filters.map((f) {
              final (value, label) = f;
              final isSelected = cubit.statusFilter == value;
              return Expanded(
                child: GestureDetector(
                  onTap: () => cubit.setFilter(value),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo-Bold',
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isSelected
                                ? activeColor
                                : AppColors.kGreyColor,
                          ),
                        ),
                      ),
                      Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? activeColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
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

  static final _statusConfig = kExchangeStatusConfig;

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
                        '${request.fromCurrency?.code ?? '—'} ← ${request.toCurrency?.code ?? '—'}',
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : AppColors.kPrimaryColor.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.10),
                ),
              ),
              child: Row(
                children: [
                  // From currency
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          _fmt(request.amount),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kRedColor,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          request.fromCurrency?.name ??
                              request.fromCurrency?.code ??
                              '—',
                          fontSize: 11,
                          color: AppColors.kGreyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  // Arrow
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.trending_flat_rounded,
                      color: AppColors.kPrimaryColor,
                      size: 18,
                    ),
                  ),
                  // To currency
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText(
                          _fmt(request.finalAmount),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kSuccessColor,
                        ),
                        const SizedBox(height: 2),
                        AppText(
                          request.toCurrency?.name ??
                              request.toCurrency?.code ??
                              '—',
                          fontSize: 11,
                          color: AppColors.kGreyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
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
    final isWhole = v == v.truncateToDouble();
    final raw = isWhole ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
    final parts = raw.split('.');
    final intWithCommas = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return parts.length > 1 ? '$intWithCommas.${parts[1]}' : intWithCommas;
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
// ACCEPTED ORDERS SUMMARY SECTION
// ─────────────────────────────────────────────────────────────────────────────

typedef _PairSummary = ({
  String fromCode,
  String fromName,
  String toCode,
  String toName,
  int count,
  double totalSent,
  double totalReceived,
  double totalCommission,
});

class _SummarySection extends StatelessWidget {
  final ExchangeRequestsCubit cubit;
  final bool isDark;

  const _SummarySection({required this.cubit, required this.isDark});

  List<_PairSummary> _compute(List<ExchangeRequestModel> accepted) {
    final map = <String, Map<String, dynamic>>{};
    for (final r in accepted) {
      final fCode = r.fromCurrency?.code ?? '?';
      final tCode = r.toCurrency?.code ?? '?';
      final key = '$fCode→$tCode';
      map.putIfAbsent(
        key,
        () => {
          'fromCode': fCode,
          'fromName': r.fromCurrency?.name ?? fCode,
          'toCode': tCode,
          'toName': r.toCurrency?.name ?? tCode,
          'count': 0,
          'sent': 0.0,
          'received': 0.0,
          'commission': 0.0,
        },
      );
      map[key]!['count'] = (map[key]!['count'] as int) + 1;
      map[key]!['sent'] = (map[key]!['sent'] as double) + (r.amount ?? 0);
      map[key]!['received'] =
          (map[key]!['received'] as double) + (r.finalAmount ?? 0);
      map[key]!['commission'] =
          (map[key]!['commission'] as double) + (r.commissionAmount ?? 0);
    }
    return map.values
        .map(
          (m) => (
            fromCode: m['fromCode'] as String,
            fromName: m['fromName'] as String,
            toCode: m['toCode'] as String,
            toName: m['toName'] as String,
            count: m['count'] as int,
            totalSent: m['sent'] as double,
            totalReceived: m['received'] as double,
            totalCommission: m['commission'] as double,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ExchangeRequestsCubit,
      SigninState<List<ExchangeRequestModel>>
    >(
      buildWhen: (_, curr) =>
          curr.maybeWhen(success: (_) => true, orElse: () => false),
      builder: (context, _) {
        final accepted = cubit.acceptedRequests;
        if (accepted.isEmpty) return const SizedBox.shrink();
        final pairs = _compute(accepted);
        return Container(
          color: isDark ? AppColors.kBackgroundDark : const Color(0xFFF0F4F8),
          padding: const EdgeInsets.fromLTRB(16, 14, 0, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.kSuccessColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const AppText(
                      'ملخص الطلبات المقبولة',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kSuccessColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AppText(
                        '${accepted.length} طلب',
                        fontSize: 10,
                        color: AppColors.kSuccessColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 178,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: pairs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) =>
                      _PairCard(pair: pairs[i], isDark: isDark),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PairCard extends StatelessWidget {
  final _PairSummary pair;
  final bool isDark;

  const _PairCard({required this.pair, required this.isDark});

  String _fmt(double v) {
    final isWhole = v == v.truncateToDouble();
    final raw = isWhole ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
    final parts = raw.split('.');
    final intWithCommas = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return parts.length > 1 ? '$intWithCommas.${parts[1]}' : intWithCommas;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 215,
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.kPrimaryColor.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.kSuccessColor, Color(0xFF15803D)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AppText(
                        pair.fromCode,
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          Icons.trending_flat_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      AppText(
                        pair.toCode,
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AppText(
                    '${pair.count} طلب',
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatRow(
                    label: 'إجمالي المُستلَم',
                    amount: _fmt(pair.totalSent),
                    currency: pair.fromName,
                    color: AppColors.kRedColor,
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.kGreyColor.withValues(alpha: 0.10),
                  ),
                  _StatRow(
                    label: 'إجمالي المُسلَّم',
                    amount: _fmt(pair.totalReceived),
                    currency: pair.toName,
                    color: AppColors.kSuccessColor,
                  ),
                  if (pair.totalCommission > 0) ...[
                    Divider(
                      height: 1,
                      color: AppColors.kGreyColor.withValues(alpha: 0.10),
                    ),
                    _StatRow(
                      label: 'إجمالي العمولة',
                      amount: _fmt(pair.totalCommission),
                      currency: pair.fromCode,
                      color: const Color(0xFFF59E0B),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String amount;
  final String currency;
  final Color color;

  const _StatRow({
    required this.label,
    required this.amount,
    required this.currency,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                label,
                fontSize: 9,
                color: AppColors.kGreyColor,
                fontWeight: FontWeight.w400,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: AppText(
                      amount,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: AppText(
                      currency,
                      fontSize: 9,
                      color: AppColors.kGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
