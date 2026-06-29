import 'package:exchange_customer/core/components/app_button.dart';
import 'package:exchange_customer/core/components/app_snackbar.dart';
import 'package:exchange_customer/core/components/app_text.dart';
import 'package:exchange_customer/core/constants/colors.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_customer/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_filter_model.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<ExchangeRequestsCubit>().fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.kBackgroundDark : const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.kPrimaryColorDarkMode : AppColors.kPrimaryColor,
        foregroundColor: Colors.white,
        title: const AppText(
          'سجل طلبات الصرف',
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          BlocBuilder<ExchangeRequestsCubit,
              SigninState<List<ExchangeRequestModel>>>(
            builder: (context, _) {
              final cubit = context.read<ExchangeRequestsCubit>();
              final count = cubit.filter.activeCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.tune_rounded, color: Colors.white),
                    onPressed: () => _openFilterSheet(context, cubit),
                    tooltip: 'تصفية الطلبات',
                  ),
                  if (count > 0)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.kWarningColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: AppText(
                            '$count',
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ExchangeRequestsCubit,
          SigninState<List<ExchangeRequestModel>>>(
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
              _ActiveFilterBar(
                filter: cubit.filter,
                cubit: cubit,
                onOpenFilter: () => _openFilterSheet(context, cubit),
                isDark: isDark,
              ),
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

  void _openFilterSheet(BuildContext context, ExchangeRequestsCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        initial: cubit.filter,
        onApply: cubit.applyFilter,
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
// ACTIVE FILTER BAR
// ─────────────────────────────────────────────────────────────────────────────

class _ActiveFilterBar extends StatelessWidget {
  final ExchangeFilterModel filter;
  final ExchangeRequestsCubit cubit;
  final VoidCallback onOpenFilter;
  final bool isDark;

  static const _statusLabels = {
    0: 'معلقة',
    1: 'مقبولة',
    2: 'مرفوضة',
    3: 'موقوفة',
  };

  const _ActiveFilterBar({
    required this.filter,
    required this.cubit,
    required this.onOpenFilter,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (!filter.isActive) return const SizedBox.shrink();

    final chips = <_FilterChipData>[];

    if (filter.statuses.isNotEmpty) {
      final labels =
          filter.statuses.map((s) => _statusLabels[s] ?? '').join('، ');
      chips.add(_FilterChipData(
        label: 'الحالة: $labels',
        onRemove: () => cubit.applyFilter(ExchangeFilterModel(
          dateFrom: filter.dateFrom,
          dateTo: filter.dateTo,
          minAmount: filter.minAmount,
          maxAmount: filter.maxAmount,
        )),
      ));
    }

    if (filter.dateFrom != null || filter.dateTo != null) {
      final from = filter.dateFrom != null
          ? '${filter.dateFrom!.day}/${filter.dateFrom!.month}'
          : '...';
      final to = filter.dateTo != null
          ? '${filter.dateTo!.day}/${filter.dateTo!.month}'
          : '...';
      chips.add(_FilterChipData(
        label: 'التاريخ: $from ← $to',
        onRemove: () => cubit.applyFilter(ExchangeFilterModel(
          statuses: filter.statuses,
          minAmount: filter.minAmount,
          maxAmount: filter.maxAmount,
        )),
      ));
    }

    if (filter.minAmount != null || filter.maxAmount != null) {
      final min = filter.minAmount?.toStringAsFixed(0) ?? '...';
      final max = filter.maxAmount?.toStringAsFixed(0) ?? '...';
      chips.add(_FilterChipData(
        label: 'المبلغ: $min — $max',
        onRemove: () => cubit.applyFilter(ExchangeFilterModel(
          statuses: filter.statuses,
          dateFrom: filter.dateFrom,
          dateTo: filter.dateTo,
        )),
      ));
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.kGreyColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: onOpenFilter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.tune_rounded,
                      size: 13,
                      color: AppColors.kPrimaryColor,
                    ),
                    const SizedBox(width: 4),
                    AppText(
                      'فلتر نشط (${filter.activeCount})',
                      fontSize: 11,
                      color: AppColors.kPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            ...chips.map(
              (c) => Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: InkWell(
                  onTap: c.onRemove,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.kGreyColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          c.label,
                          fontSize: 11,
                          color: AppColors.kGreyColor,
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.close_rounded,
                          size: 12,
                          color: AppColors.kGreyColor.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => cubit.applyFilter(const ExchangeFilterModel()),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.kRedColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.kRedColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: 12,
                      color: AppColors.kRedColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    AppText(
                      'مسح الكل',
                      fontSize: 11,
                      color: AppColors.kRedColor.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipData {
  final String label;
  final VoidCallback onRemove;
  const _FilterChipData({required this.label, required this.onRemove});
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  final ExchangeFilterModel initial;
  final void Function(ExchangeFilterModel) onApply;

  const _FilterSheet({required this.initial, required this.onApply});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late List<int> _statuses;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  final _minCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();

  static const _statusConfig = {
    0: (
      color: Color(0xFFF59E0B),
      label: 'معلقة',
      icon: Icons.hourglass_empty_rounded,
    ),
    1: (
      color: Color(0xFF16A34A),
      label: 'مقبولة',
      icon: Icons.check_circle_rounded,
    ),
    2: (
      color: Color(0xFFDC2626),
      label: 'مرفوضة',
      icon: Icons.cancel_rounded,
    ),
    3: (
      color: Color(0xFF64748B),
      label: 'موقوفة',
      icon: Icons.pause_circle_rounded,
    ),
  };

  @override
  void initState() {
    super.initState();
    _statuses = List.from(widget.initial.statuses);
    _dateFrom = widget.initial.dateFrom;
    _dateTo = widget.initial.dateTo;
    _minCtrl.text = widget.initial.minAmount?.toStringAsFixed(0) ?? '';
    _maxCtrl.text = widget.initial.maxAmount?.toStringAsFixed(0) ?? '';
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  void _toggleStatus(int value) {
    setState(() {
      if (_statuses.contains(value)) {
        _statuses.remove(value);
      } else {
        _statuses.add(value);
      }
    });
  }

  Future<void> _pickDate(bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (_dateFrom ?? now)
          : (_dateTo ?? (_dateFrom != null ? _dateFrom! : now)),
      firstDate: isFrom ? DateTime(2020) : (_dateFrom ?? DateTime(2020)),
      lastDate: isFrom ? (_dateTo ?? now) : now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.kPrimaryColor,
            onSurface: AppColors.kFontColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
        } else {
          _dateTo = picked;
        }
      });
    }
  }

  void _clearAll() {
    setState(() {
      _statuses.clear();
      _dateFrom = null;
      _dateTo = null;
      _minCtrl.clear();
      _maxCtrl.clear();
    });
  }

  void _apply() {
    final minText = _minCtrl.text.trim();
    final maxText = _maxCtrl.text.trim();
    widget.onApply(ExchangeFilterModel(
      statuses: List.from(_statuses),
      dateFrom: _dateFrom,
      dateTo: _dateTo,
      minAmount: minText.isEmpty ? null : double.tryParse(minText),
      maxAmount: maxText.isEmpty ? null : double.tryParse(maxText),
    ));
    Navigator.pop(context);
  }

  bool get _hasChanges {
    final min = _minCtrl.text.trim();
    final max = _maxCtrl.text.trim();
    return _statuses.isNotEmpty ||
        _dateFrom != null ||
        _dateTo != null ||
        min.isNotEmpty ||
        max.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.kGreyColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ── Header ──
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 18,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                const AppText(
                  'تصفية الطلبات',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 15,
                    color: AppColors.kGreyColor,
                  ),
                  label: const AppText(
                    'مسح الكل',
                    fontSize: 13,
                    color: AppColors.kGreyColor,
                    fontWeight: FontWeight.w400,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.kGreyColor,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Section 1: Status ──
            _SectionLabel(
              icon: Icons.flag_outlined,
              label: 'الحالة',
              isDark: isDark,
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _statusConfig.entries.map((entry) {
                final value = entry.key;
                final cfg = entry.value;
                final selected = _statuses.contains(value);
                return GestureDetector(
                  onTap: () => _toggleStatus(value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? cfg.color.withValues(alpha: 0.12)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? cfg.color.withValues(alpha: 0.6)
                            : AppColors.kGreyColor.withValues(alpha: 0.2),
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cfg.icon,
                          size: 14,
                          color: selected ? cfg.color : AppColors.kGreyColor,
                        ),
                        const SizedBox(width: 6),
                        AppText(
                          cfg.label,
                          fontSize: 13,
                          color: selected ? cfg.color : AppColors.kGreyColor,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                        if (selected) ...[
                          const SizedBox(width: 5),
                          Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: cfg.color,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Divider(
              height: 1,
              color: AppColors.kGreyColor.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 20),

            // ── Section 2: Date Range ──
            _SectionLabel(
              icon: Icons.calendar_today_outlined,
              label: 'نطاق التاريخ',
              isDark: isDark,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _DatePickerButton(
                    label: 'من',
                    date: _dateFrom,
                    onTap: () => _pickDate(true),
                    onClear: _dateFrom != null
                        ? () => setState(() => _dateFrom = null)
                        : null,
                    isDark: isDark,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    size: 20,
                    color: AppColors.kGreyColor.withValues(alpha: 0.5),
                  ),
                ),
                Expanded(
                  child: _DatePickerButton(
                    label: 'إلى',
                    date: _dateTo,
                    onTap: () => _pickDate(false),
                    onClear: _dateTo != null
                        ? () => setState(() => _dateTo = null)
                        : null,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Divider(
              height: 1,
              color: AppColors.kGreyColor.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 20),

            // ── Section 3: Amount Range ──
            _SectionLabel(
              icon: Icons.account_balance_wallet_outlined,
              label: 'نطاق المبلغ',
              isDark: isDark,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _AmountField(
                    controller: _minCtrl,
                    hint: 'الحد الأدنى',
                    isDark: isDark,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AppText(
                    '—',
                    color: AppColors.kGreyColor.withValues(alpha: 0.5),
                    fontSize: 18,
                  ),
                ),
                Expanded(
                  child: _AmountField(
                    controller: _maxCtrl,
                    hint: 'الحد الأقصى',
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ── Action Buttons ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: AppColors.kGreyColor.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const AppText(
                      'إلغاء',
                      color: AppColors.kGreyColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    text: _hasChanges ? 'تطبيق الفلتر' : 'تطبيق',
                    icon: _hasChanges ? Icons.check_rounded : null,
                    onPressed: _apply,
                    height: 48,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FILTER SHEET HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: AppColors.kGreyColor),
            const SizedBox(width: 6),
            AppText(
              label,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          height: 2,
          width: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF16A34A),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}

class _DatePickerButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final bool isDark;

  const _DatePickerButton({
    required this.label,
    required this.date,
    required this.onTap,
    required this.onClear,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: hasDate
              ? AppColors.kPrimaryColor.withValues(alpha: 0.07)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasDate
                ? AppColors.kPrimaryColor.withValues(alpha: 0.4)
                : AppColors.kGreyColor.withValues(alpha: 0.2),
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: hasDate ? AppColors.kPrimaryColor : AppColors.kGreyColor,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    label,
                    fontSize: 10,
                    color: AppColors.kGreyColor,
                    fontWeight: FontWeight.w400,
                  ),
                  AppText(
                    hasDate
                        ? '${date!.day}/${date!.month}/${date!.year}'
                        : 'اختر تاريخ',
                    fontSize: 12,
                    color: hasDate
                        ? AppColors.kPrimaryColor
                        : AppColors.kGreyColor.withValues(alpha: 0.5),
                    fontWeight:
                        hasDate ? FontWeight.w700 : FontWeight.w400,
                  ),
                ],
              ),
            ),
            if (hasDate && onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: AppColors.kGreyColor.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDark;

  const _AmountField({
    required this.controller,
    required this.hint,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Cairo-Bold',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.kFontColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Cairo-Bold',
          fontSize: 12,
          color: AppColors.kGreyColor.withValues(alpha: 0.55),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : const Color(0xFFF8FAFC),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.kGreyColor.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.kGreyColor.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.kPrimaryColor,
            width: 1.5,
          ),
        ),
      ),
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
    2: (
      color: AppColors.kRedColor,
      label: 'مرفوض',
      icon: Icons.cancel_rounded,
    ),
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
              BlocBuilder<ExchangeRequestsCubit,
                  SigninState<List<ExchangeRequestModel>>>(
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
                child: CircularProgressIndicator(
                  color: color,
                  strokeWidth: 2,
                ),
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
