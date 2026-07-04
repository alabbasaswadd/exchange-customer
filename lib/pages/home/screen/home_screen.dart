import 'dart:math' show min;
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:exchange_customer/core/components/app_alert_dialog.dart';
import 'package:exchange_customer/core/components/app_button.dart';
import 'package:exchange_customer/core/components/app_snackbar.dart';
import 'package:exchange_customer/core/components/app_text.dart';
import 'package:exchange_customer/core/components/app_text_form_field.dart';
import 'package:exchange_customer/core/components/custom_appbar.dart';
import 'package:exchange_customer/core/constants/colors.dart';
import 'package:exchange_customer/core/constants/functions.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_cubit.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_customer/pages/currencies/cubit/currencies_cubit.dart';
import 'package:exchange_customer/pages/currencies/model/currency_model.dart';
import 'package:exchange_customer/pages/exchange_rates/cubit/exchange_rates_cubit.dart';
import 'package:exchange_customer/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:exchange_customer/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_customer/pages/notifications/cubit/notifications_cubit.dart';
import 'package:exchange_customer/pages/notifications/cubit/notifications_state.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────────────────────────

Future<void> _launchShamCash(BuildContext context) async {
  const pkg = 'com.shmacash.shamcash';
  const routes = [
    '/send',
    '/transfer',
    '/new-order',
    '/create-order',
    '/exchange',
  ];
  for (final route in routes) {
    try {
      await AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: pkg,
        componentName: '$pkg.MainActivity',
        arguments: <String, dynamic>{'route': route},
        flags: <int>[
          Flag.FLAG_ACTIVITY_NEW_TASK,
          Flag.FLAG_ACTIVITY_CLEAR_TASK,
        ],
      ).launch();
      return;
    } catch (_) {
      continue;
    }
  }
  try {
    await LaunchApp.openApp(androidPackageName: pkg, openStore: false);
  } catch (_) {
    if (context.mounted)
      AppSnackbar.showError(context, 'تطبيق شام كاش غير مثبت');
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.kBackgroundDark
          : const Color(0xFFF0F4F8),
      appBar: CustomAppBar(
        title: 'مرحبا ${UserSession.fullName}',
        centerTitle: false,
        fontColor: Colors.white,
        backgroundColor: isDark
            ? AppColors.kPrimaryColorDarkMode
            : AppColors.kPrimaryColor,
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, _) {
              final unread = context.read<NotificationsCubit>().unreadCount;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => context.push('/notifications'),
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 8,
                      right: 6,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.kRedColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: AppText(
                          unread > 9 ? '9+' : '$unread',
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AppAlertDialog(
                  onOk: () {
                    context.read<SigninCubit>().logout();
                    ctx.go('/signin');
                  },
                  onNo: ctx.pop,
                  title: 'تسجيل الخروج',
                  content: 'هل تريد تسجيل الخروج؟',
                ),
              );
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
        ],
      ),
      body: const _HomeBody(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME BODY  (stateful — owns animation + from/to currency selection)
// ─────────────────────────────────────────────────────────────────────────────

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody>
    with SingleTickerProviderStateMixin {
  String _fromCode = '';
  String _toCode = '';

  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.kPrimaryColor,
        onRefresh: () => Future.wait([
          context.read<ExchangeRatesCubit>().fetchRates(),
          context.read<CurrenciesCubit>().fetchCurrencies(),
          context.read<ExchangeRequestsCubit>().fetchRequests(),
        ]),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildRateCard(context),
                  const SizedBox(height: 32),
                  _buildMyRequestsSection(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Rate Card ─────────────────────────────────────────────────────────────

  Widget _buildRateCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.kPrimaryColorDarkMode,
                  AppColors.kSecondColorDarkMode,
                ]
              : [AppColors.kPrimaryColor, const Color(0xFF047857)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<CurrenciesCubit, SigninState<List<CurrencyModel>>>(
        builder: (context, currState) {
          final currencies = currState.maybeWhen(
            success: (c) => c,
            orElse: () => <CurrencyModel>[],
          );
          if (_fromCode.isEmpty && currencies.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  final usd = currencies.firstWhere(
                    (c) => c.code == 'USD',
                    orElse: () => currencies.first,
                  );
                  final syp = currencies.firstWhere(
                    (c) => c.code == 'SYP',
                    orElse: () => currencies.length > 1
                        ? currencies[1]
                        : currencies.first,
                  );
                  _fromCode = usd.code ?? '';
                  _toCode = syp.code ?? '';
                });
              }
            });
          }
          CurrencyModel? fromCurr, toCurr;
          for (final c in currencies) {
            if (c.code == _fromCode) fromCurr = c;
            if (c.code == _toCode) toCurr = c;
          }
          return BlocBuilder<
            ExchangeRatesCubit,
            SigninState<List<ExchangeRateModel>>
          >(
            builder: (context, rateState) {
              final isLoading = rateState.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );
              final rates = rateState.maybeWhen(
                success: (r) => r,
                orElse: () => <ExchangeRateModel>[],
              );
              final codeToId = {
                for (final c in currencies)
                  if (c.code != null && c.id != null) c.code!: c.id!,
              };
              final fromId = codeToId[_fromCode];
              final toId = codeToId[_toCode];
              ExchangeRateModel? rate;
              for (final r in rates) {
                final byId =
                    fromId != null &&
                    toId != null &&
                    r.fromCurrencyId == fromId &&
                    r.toCurrencyId == toId;
                final byCode =
                    r.fromCurrency?.code == _fromCode &&
                    r.toCurrency?.code == _toCode;
                if (byId || byCode) {
                  rate = r;
                  break;
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(
                          Icons.currency_exchange_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const AppText(
                        'سعر الصرف',
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _CurrencyRatePairCard(
                    fromCode: _fromCode,
                    toCode: _toCode,
                    fromCurr: fromCurr,
                    toCurr: toCurr,
                    rate: rate,
                    isLoading: isLoading,
                    onPickFrom: () =>
                        _showCurrencyPicker(context, true, currencies),
                    onPickTo: () =>
                        _showCurrencyPicker(context, false, currencies),
                    onSwap: () => setState(() {
                      final tmp = _fromCode;
                      _fromCode = _toCode;
                      _toCode = tmp;
                    }),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () =>
                        _showRequestSheet(context, fromCurr, toCurr, rate),
                    child: Container(
                      width: double.infinity,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send_rounded,
                            color: AppColors.kPrimaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          AppText(
                            'طلب صرف',
                            fontSize: 14,
                            color: AppColors.kPrimaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // ── Sham Cash Card ────────────────────────────────────────────────────────

  // ── Recent Requests Section ───────────────────────────────────────────────

  Widget _buildMyRequestsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _sectionHeader(
                'آخر طلبات الصرف',
                Icons.receipt_long_rounded,
                isDark,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/history'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const AppText(
                'السجل الكامل',
                fontSize: 12,
                color: AppColors.kPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BlocBuilder<
          ExchangeRequestsCubit,
          SigninState<List<ExchangeRequestModel>>
        >(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => _listShimmer(isDark),
              success: (all) {
                final recent = all.take(5).toList();
                if (recent.isEmpty) return _emptyState('لا توجد طلبات صرف بعد');
                return Column(
                  children: recent
                      .asMap()
                      .entries
                      .map(
                        (e) => _RequestRow(
                          request: e.value,
                          isDark: isDark,
                          isLast: e.key == recent.length - 1,
                          // onTap: () => _openRequestDetail(context, e.value),
                        ),
                      )
                      .toList(),
                );
              },
              error: (_) => _emptyState('تعذّر تحميل الطلبات'),
            );
          },
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.kPrimaryColor, Color(0xFF047857)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        AppText(title, fontSize: 15, fontWeight: FontWeight.w700),
      ],
    );
  }

  Widget _listShimmer(bool isDark, {int count = 3}) {
    return Column(
      children: List.generate(
        count,
        (i) => Container(
          margin: EdgeInsets.only(bottom: i < count - 1 ? 10 : 0),
          height: 72,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _emptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 42,
              color: AppColors.kGreyColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 10),
            AppText(
              message,
              fontSize: 13,
              color: AppColors.kGreyColor,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestSheet(
    BuildContext context,
    CurrencyModel? fromCurr,
    CurrencyModel? toCurr,
    ExchangeRateModel? rate,
  ) {
    final fromId = fromCurr?.id ?? '';
    final toId = toCurr?.id ?? '';
    if (fromId.isEmpty || toId.isEmpty) {
      AppSnackbar.showError(context, 'يرجى اختيار العملتين أولاً');
      return;
    }
    final requestCubit = context.read<ExchangeRequestsCubit>();
    final allRates = context.read<ExchangeRatesCubit>().state.maybeWhen(
      success: (r) => r,
      orElse: () => <ExchangeRateModel>[],
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: requestCubit,
        child: _RequestExchangeSheet(
          fromCurrencyId: fromId,
          toCurrencyId: toId,
          fromCurr: fromCurr,
          toCurr: toCurr,
          rate: rate,
          allRates: allRates,
        ),
      ),
    );
  }

  void _showCurrencyPicker(
    BuildContext context,
    bool isFrom,
    List<CurrencyModel> currencies,
  ) {
    final currCubit = context.read<CurrenciesCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: currCubit,
        child: _CurrencyPickerSheet(
          selectedCode: isFrom ? _fromCode : _toCode,
          onSelected: (code) => setState(() {
            if (isFrom) {
              _fromCode = code;
            } else {
              _toCode = code;
            }
          }),
        ),
      ),
    );
  }

  // void _openRequestDetail(BuildContext context, ExchangeRequestModel request) {
  //   final cubit = context.read<ExchangeRequestsCubit>();
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) => BlocProvider.value(
  //       value: cubit,
  //       child: RequestDetailSheet(request: request),
  //     ),
  //   );
  // }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY RATE PAIR CARD  (2-column layout: from|to with buy|sell rates)
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyRatePairCard extends StatelessWidget {
  final String fromCode;
  final String toCode;
  final CurrencyModel? fromCurr;
  final CurrencyModel? toCurr;
  final ExchangeRateModel? rate;
  final bool isLoading;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSwap;

  const _CurrencyRatePairCard({
    required this.fromCode,
    required this.toCode,
    required this.fromCurr,
    required this.toCurr,
    required this.rate,
    required this.isLoading,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSwap,
  });

  Widget _sideBox({
    required String label,
    required String code,
    required String? name,
    required String rateLabel,
    required double? rateValue,
    required Color rateColor,
    required IconData rateIcon,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: _CurrencyRateColumn(
        label: label,
        code: code,
        name: name,
        rateLabel: rateLabel,
        rateValue: rateValue,
        rateColor: rateColor,
        rateIcon: rateIcon,
        isLoading: isLoading,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _sideBox(
            label: 'من',
            code: fromCode,
            name: fromCurr?.name,
            rateLabel: 'سعر الشراء',
            rateValue: rate?.buyRate,
            rateColor: const Color(0xFF34D399),
            rateIcon: Icons.trending_up_rounded,
            onTap: onPickFrom,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: onSwap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        Expanded(
          child: _sideBox(
            label: 'إلى',
            code: toCode,
            name: toCurr?.name,
            rateLabel: 'سعر البيع',
            rateValue: rate?.sellRate,
            rateColor: const Color(0xFFFCA5A5),
            rateIcon: Icons.trending_down_rounded,
            onTap: onPickTo,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY RATE COLUMN  (one side of the pair card)
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyRateColumn extends StatelessWidget {
  final String label;
  final String code;
  final String? name;
  final String rateLabel;
  final double? rateValue;
  final Color rateColor;
  final IconData rateIcon;
  final bool isLoading;
  final VoidCallback onTap;

  const _CurrencyRateColumn({
    required this.label,
    required this.code,
    required this.name,
    required this.rateLabel,
    required this.rateValue,
    required this.rateColor,
    required this.rateIcon,
    required this.isLoading,
    required this.onTap,
  });

  String _fmt(double v) =>
      v < 100 ? v.toStringAsFixed(2) : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                label,
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white.withValues(alpha: 0.6),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 4),
          AppText(
            code.isEmpty ? '—' : code,
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          if (name != null)
            AppText(
              name!,
              fontSize: 9,
              color: Colors.white.withValues(alpha: 0.55),
              fontWeight: FontWeight.w400,
              maxLines: 1,
            ),
          const SizedBox(height: 12),
          Container(height: 0.5, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 10),
          if (isLoading) ...[
            Container(
              height: 10,
              width: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 22,
              width: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Icon(rateIcon, color: rateColor, size: 12),
                const SizedBox(width: 4),
                AppText(
                  rateLabel,
                  fontSize: 10,
                  color: rateColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const SizedBox(height: 3),
            AppText(
              rateValue != null ? _fmt(rateValue!) : '—',
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REQUEST EXCHANGE SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _RequestExchangeSheet extends StatefulWidget {
  final String fromCurrencyId;
  final String toCurrencyId;
  final CurrencyModel? fromCurr;
  final CurrencyModel? toCurr;
  final ExchangeRateModel? rate;
  final List<ExchangeRateModel> allRates;

  const _RequestExchangeSheet({
    required this.fromCurrencyId,
    required this.toCurrencyId,
    required this.fromCurr,
    required this.toCurr,
    required this.rate,
    required this.allRates,
  });

  @override
  State<_RequestExchangeSheet> createState() => _RequestExchangeSheetState();
}

class _RequestExchangeSheetState extends State<_RequestExchangeSheet> {
  late final ExchangeRequestsCubit _cubit;
  String _amountText = '';

  late String _fromId;
  late String _toId;
  CurrencyModel? _fromCurr;
  CurrencyModel? _toCurr;
  ExchangeRateModel? _rate;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ExchangeRequestsCubit>();
    _fromId = widget.fromCurrencyId;
    _toId = widget.toCurrencyId;
    _fromCurr = widget.fromCurr;
    _toCurr = widget.toCurr;
    _rate = widget.rate;
    _amountText = _cubit.amountController.text;
    _cubit.amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _cubit.amountController.removeListener(_onAmountChanged);
    super.dispose();
  }

  void _onAmountChanged() {
    if (mounted) setState(() => _amountText = _cubit.amountController.text);
  }

  void _swap() {
    final newFromId = _toId;
    final newToId = _fromId;
    final newFromCurr = _toCurr;
    final newToCurr = _fromCurr;
    ExchangeRateModel? newRate;
    for (final r in widget.allRates) {
      final byId = r.fromCurrencyId == newFromId && r.toCurrencyId == newToId;
      final byCode =
          r.fromCurrency?.code == newFromCurr?.code &&
          r.toCurrency?.code == newToCurr?.code;
      if (byId || byCode) {
        newRate = r;
        break;
      }
    }
    setState(() {
      _fromId = newFromId;
      _toId = newToId;
      _fromCurr = newFromCurr;
      _toCurr = newToCurr;
      _rate = newRate;
    });
  }

  String _fmt(double v) =>
      v < 100 ? v.toStringAsFixed(3) : v.toStringAsFixed(2);

  String _fmtAmount(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(3)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(2)}K';
    return v < 100 ? v.toStringAsFixed(3) : v.toStringAsFixed(2);
  }

  ({double gross, double commPercent, double commAmount, double expected})?
  _getCalcDetails() {
    final amount = double.tryParse(_amountText.trim());
    if (amount == null || amount <= 0) return null;
    final r = _rate;
    if (r == null || r.buyRate == null) return null;
    final rateValue = r.buyRate!;
    final commPercent = (r.commissionPercent ?? 0).toDouble();
    final gross = amount * rateValue;
    final commAmount = gross * commPercent / 100;
    final expected = gross - commAmount;
    return (
      gross: gross,
      commPercent: commPercent,
      commAmount: commAmount,
      expected: expected,
    );
  }

  Widget _buildCurrencyPair(bool isDark, Color labelColor) {
    final rateValue = _rate?.buyRate;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : AppColors.kPrimaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.kPrimaryColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // From currency
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'من',
                      fontSize: 10,
                      color: labelColor,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 6),
                    AppText(
                      _fromCurr?.code ?? '—',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    if (_fromCurr?.name != null)
                      AppText(
                        _fromCurr!.name!,
                        fontSize: 11,
                        color: labelColor,
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              // Swap button
              GestureDetector(
                onTap: _swap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kPrimaryColor.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.swap_horiz_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              // To currency
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      'إلى',
                      fontSize: 10,
                      color: labelColor,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 6),
                    AppText(
                      _toCurr?.code ?? '—',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    if (_toCurr?.name != null)
                      AppText(
                        _toCurr!.name!,
                        fontSize: 11,
                        color: labelColor,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (rateValue != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.currency_exchange_rounded,
                    size: 12,
                    color: AppColors.kPrimaryColor,
                  ),
                  const SizedBox(width: 6),
                  AppText(
                    '1 ${_fromCurr?.code ?? ''} = ${_fmt(rateValue)} ${_toCurr?.code ?? ''}',
                    fontSize: 12,
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCalcPanel(bool isDark, Color labelColor) {
    final details = _getCalcDetails();
    final bg = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : const Color(0xFFF8FAFC);
    final borderCol = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE2E8F0);
    final divCol = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : const Color(0xFFE9EFF5);
    final toCurrency = _toCurr?.code ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderCol),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  size: 13,
                  color: AppColors.kPrimaryColor,
                ),
              ),
              const SizedBox(width: 8),
              const AppText(
                'تفاصيل الحساب',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.kPrimaryColor,
              ),
            ],
          ),
          if (details == null) ...[
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.calculate_outlined,
                    size: 30,
                    color: labelColor.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    'أدخل المبلغ لعرض تفاصيل العملية',
                    fontSize: 12,
                    color: labelColor,
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 14),
            Divider(height: 1, color: divCol),
            const SizedBox(height: 12),
            _CalcDetailRow(
              label: 'المبلغ الإجمالي',
              value: '${_fmtAmount(details.gross)} $toCurrency',
              labelColor: labelColor,
            ),
            const SizedBox(height: 10),
            _CalcDetailRow(
              label: 'نسبة العمولة',
              value: details.commPercent % 1 == 0
                  ? '${details.commPercent.toInt()}%'
                  : '${details.commPercent.toStringAsFixed(2)}%',
              labelColor: labelColor,
            ),
            const SizedBox(height: 10),
            _CalcDetailRow(
              label: 'مبلغ العمولة',
              value: details.commAmount > 0
                  ? '- ${_fmtAmount(details.commAmount)} $toCurrency'
                  : '—',
              labelColor: labelColor,
              valueColor: details.commAmount > 0 ? AppColors.kRedColor : null,
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: divCol),
            const SizedBox(height: 14),
            // Final amount row — highlighted
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.kSuccessColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const AppText(
                      'المبلغ النهائي',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText('≈ ', fontSize: 13, color: labelColor),
                    AppText(
                      '${_fmtAmount(details.expected)} $toCurrency',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kSuccessColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white60 : Colors.black54;

    return BlocConsumer<
      ExchangeRequestsCubit,
      SigninState<List<ExchangeRequestModel>>
    >(
      listenWhen: (previous, current) =>
          previous.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.whenOrNull(
          success: (_) {
            AppSnackbar.showSuccess(context, 'تم إرسال طلب الصرف بنجاح');
            Navigator.of(context).pop();
          },
          error: (msg) => AppSnackbar.showError(context, msg),
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.kBackgroundDark : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.kGreyColor.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Sheet title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.currency_exchange_rounded,
                          color: AppColors.kPrimaryColor,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const AppText(
                        'طلب صرف عملة',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Currency pair with swap button
                  _buildCurrencyPair(isDark, labelColor),
                  const SizedBox(height: 16),

                  // Amount field
                  AppTextFormField(
                    label: 'المبلغ',
                    controller: _cubit.amountController,
                    hintText: 'أدخل المبلغ',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 4-metric calculation breakdown
                  _buildCalcPanel(isDark, labelColor),
                  const SizedBox(height: 24),

                  // Submit button
                  AppButton(
                    text: 'إرسال الطلب',
                    onPressed: () {
                      final raw = _cubit.amountController.text.trim();
                      if (raw.isEmpty) {
                        AppSnackbar.showError(context, 'يرجى إدخال المبلغ');
                        return;
                      }
                      final amount = double.tryParse(raw);
                      if (amount == null || amount <= 0) {
                        AppSnackbar.showError(context, 'يرجى إدخال مبلغ صحيح');
                        return;
                      }
                      _cubit.submitRequest(
                        fromCurrencyId: _fromId,
                        toCurrencyId: _toId,
                      );
                    },
                    isLoading: isLoading,
                    icon: Icons.send_rounded,
                    padding: EdgeInsets.zero,
                    height: 52,
                    borderRadius: 14,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REQUEST ROW  (card style)
// ─────────────────────────────────────────────────────────────────────────────

class _RequestRow extends StatelessWidget {
  final ExchangeRequestModel request;
  final bool isDark;
  final bool isLast;
  final VoidCallback? onTap;

  const _RequestRow({
    required this.request,
    required this.isDark,
    required this.isLast,
    this.onTap,
  });

  static const _statusConfig = {
    0: (
      icon: Icons.hourglass_empty_rounded,
      color: Color(0xFFF59E0B),
      label: 'معلّق',
    ),
    1: (
      icon: Icons.check_rounded,
      color: AppColors.kSuccessColor,
      label: 'مقبول',
    ),
    2: (icon: Icons.close_rounded, color: AppColors.kRedColor, label: 'مرفوض'),
    3: (icon: Icons.pause_rounded, color: AppColors.kGreyColor, label: 'موقوف'),
  };

  @override
  Widget build(BuildContext context) {
    final cfg =
        _statusConfig[request.status] ??
        (
          icon: Icons.help_outline_rounded,
          color: AppColors.kGreyColor,
          label: '—',
        );

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // status icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: cfg.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(cfg.icon, color: cfg.color, size: 20),
                ),
                const SizedBox(width: 12),
                // content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              request.user?.fullName ?? '—',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: cfg.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: AppText(
                              cfg.label,
                              fontSize: 10,
                              color: cfg.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          AppText(
                            '${_fmt(request.amount)} ${request.fromCurrency?.code ?? ''}',
                            fontSize: 11,
                            color: AppColors.kRedColor,
                            fontWeight: FontWeight.w600,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 10,
                              color: AppColors.kGreyColor,
                            ),
                          ),
                          AppText(
                            '${_fmt(request.finalAmount)} ${request.toCurrency?.code ?? ''}',
                            fontSize: 11,
                            color: AppColors.kSuccessColor,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          AppText(
                            _fmtDate(request.createdAt ?? request.createdOn),
                            fontSize: 10,
                            color: AppColors.kGreyColor.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_left_rounded,
                  size: 18,
                  color: AppColors.kGreyColor.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _fmt(double? v) {
    if (v == null) return '—';
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }

  String _fmtDate(String? d) {
    if (d == null) return '';
    try {
      final dt = DateTime.parse(d);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return d;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EDIT RATE BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _EditRateSheet extends StatelessWidget {
  final ExchangeRateModel rate;

  const _EditRateSheet({required this.rate});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExchangeRatesCubit>();
    return BlocConsumer<
      ExchangeRatesCubit,
      SigninState<List<ExchangeRateModel>>
    >(
      listenWhen: (p, c) =>
          p.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            AppSnackbar.showSuccess(context, 'تم تحديث سعر الصرف بنجاح');
            Navigator.pop(context);
          },
          error: (msg) => AppSnackbar.showError(context, msg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        return _BottomSheet(
          title: 'تعديل سعر الصرف',
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                AppTextFormField(
                  label: 'سعر الشراء',
                  controller: cubit.buyRateController,
                  icon: Icons.trending_up_rounded,
                  prefixIconColor: AppColors.kSuccessColor,
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'سعر البيع',
                  controller: cubit.sellRateController,
                  icon: Icons.trending_down_rounded,
                  prefixIconColor: AppColors.kRedColor,
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'نسبة العمولة %',
                  controller: cubit.commissionController,
                  icon: Icons.percent_rounded,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY PICKER BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final String selectedCode;
  final ValueChanged<String> onSelected;

  const _CurrencyPickerSheet({
    required this.selectedCode,
    required this.onSelected,
  });

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.kCardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          const SizedBox(height: 14),
          const AppText(
            'اختر العملة',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 14),
          _searchField(isDark),
          const SizedBox(height: 12),
          BlocBuilder<CurrenciesCubit, SigninState<List<CurrencyModel>>>(
            builder: (context, state) {
              final all = state.maybeWhen(
                success: (c) => c,
                orElse: () => <CurrencyModel>[],
              );
              final filtered = _query.isEmpty
                  ? all
                  : all
                        .where(
                          (c) =>
                              (c.code?.toLowerCase().contains(_query) ??
                                  false) ||
                              (c.name?.toLowerCase().contains(_query) ??
                                  false) ||
                              (c.symbol?.toLowerCase().contains(_query) ??
                                  false),
                        )
                        .toList();

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: min(filtered.length * 66.0 + 8, 300),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                  itemBuilder: (ctx, i) {
                    final c = filtered[i];
                    return _CurrencyPickerItem(
                      currency: c,
                      isSelected: c.code == widget.selectedCode,
                      onTap: () {
                        widget.onSelected(c.code!);
                        Navigator.pop(context);
                      },
                      onLongPress: () => _openEdit(context, c),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _addButton(context),
        ],
      ),
    );
  }

  Widget _handle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.kGreyColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _searchField(bool isDark) {
    return TextField(
      onChanged: (v) => setState(() => _query = v.toLowerCase().trim()),
      style: const TextStyle(fontFamily: 'Cairo-Bold', fontSize: 13),
      decoration: InputDecoration(
        hintText: 'ابحث عن عملة...',
        hintStyle: const TextStyle(
          fontFamily: 'Cairo-Bold',
          fontSize: 13,
          color: AppColors.kGreyColor,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.kGreyColor,
          size: 20,
        ),
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : const Color(0xFFF0F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _openAdd(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.kPrimaryColor,
          side: BorderSide(
            color: AppColors.kPrimaryColor.withValues(alpha: 0.45),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
        label: const AppText(
          'إضافة عملة جديدة',
          fontSize: 13,
          color: AppColors.kPrimaryColor,
        ),
      ),
    );
  }

  void _openEdit(BuildContext context, CurrencyModel currency) {
    final cubit = context.read<CurrenciesCubit>();
    cubit.prepareForEdit(currency);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _CurrencyFormSheet(isEdit: true, currencyId: currency.id),
      ),
    );
  }

  void _openAdd(BuildContext context) {
    final cubit = context.read<CurrenciesCubit>();
    cubit.prepareForAdd();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _CurrencyFormSheet(isEdit: false),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY PICKER LIST ITEM
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyPickerItem extends StatelessWidget {
  final CurrencyModel currency;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CurrencyPickerItem({
    required this.currency,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currency.isActive ?? false;
    final gradientColors = isActive
        ? [AppColors.kPrimaryColor, const Color(0xFF047857)]
        : [AppColors.kGreyColor, const Color(0xFF94A3B8)];

    return Material(
      color: isSelected
          ? AppColors.kPrimaryColor.withValues(alpha: 0.05)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: AppText(
                  currency.symbol ?? '',
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      currency.code ?? '',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    AppText(
                      currency.name ?? '',
                      fontSize: 11,
                      color: AppColors.kGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              if (!isActive)
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kGreyColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const AppText(
                    'معطل',
                    fontSize: 9,
                    color: AppColors.kGreyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.kPrimaryColor,
                    size: 20,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.more_vert_rounded,
                    size: 16,
                    color: AppColors.kGreyColor.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY FORM SHEET  (add / edit)
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyFormSheet extends StatefulWidget {
  final bool isEdit;
  final String? currencyId;

  const _CurrencyFormSheet({required this.isEdit, this.currencyId});

  @override
  State<_CurrencyFormSheet> createState() => _CurrencyFormSheetState();
}

class _CurrencyFormSheetState extends State<_CurrencyFormSheet> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CurrenciesCubit>();
    return BlocConsumer<CurrenciesCubit, SigninState<List<CurrencyModel>>>(
      listenWhen: (p, c) =>
          p.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            AppSnackbar.showSuccess(
              context,
              widget.isEdit ? 'تم تحديث العملة' : 'تمت إضافة العملة',
            );
            Navigator.pop(context);
          },
          error: (msg) => AppSnackbar.showError(context, msg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        return _BottomSheet(
          title: widget.isEdit ? 'تعديل العملة' : 'إضافة عملة جديدة',
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                AppTextFormField(
                  label: 'اسم العملة',
                  controller: cubit.nameController,
                  icon: Icons.label_outline_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'رمز العملة (مثال: USD)',
                  controller: cubit.codeController,
                  icon: Icons.code_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                AppTextFormField(
                  label: 'الرمز (مثال: \$)',
                  controller: cubit.symbolController,
                  icon: Icons.attach_money_rounded,
                  validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 6, 5, 4),
                  child: Row(
                    children: [
                      const AppText('حالة العملة', fontSize: 14),
                      const Spacer(),
                      StatefulBuilder(
                        builder: (_, set) => Switch.adaptive(
                          value: cubit.isActiveValue,
                          activeColor: AppColors.kPrimaryColor,
                          onChanged: (v) => set(() => cubit.isActiveValue = v),
                        ),
                      ),
                      AppText(
                        cubit.isActiveValue ? 'نشطة' : 'معطلة',
                        fontSize: 12,
                        color: cubit.isActiveValue
                            ? AppColors.kSuccessColor
                            : AppColors.kGreyColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: widget.isEdit ? 'حفظ التعديلات' : 'إضافة العملة',
                  onPressed: () => widget.isEdit
                      ? cubit.updateCurrency(widget.currencyId!)
                      : cubit.addCurrency(),
                  isLoading: isLoading,
                  icon: widget.isEdit ? Icons.save_rounded : Icons.add_rounded,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALC DETAIL ROW
// ─────────────────────────────────────────────────────────────────────────────

class _CalcDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color? valueColor;

  const _CalcDetailRow({
    required this.label,
    required this.value,
    required this.labelColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, fontSize: 12, color: labelColor),
        AppText(
          value,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: valueColor,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED BOTTOM SHEET CONTAINER
// ─────────────────────────────────────────────────────────────────────────────

class _BottomSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _BottomSheet({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.kGreyColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          AppText(title, fontSize: 16, fontWeight: FontWeight.w700),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
