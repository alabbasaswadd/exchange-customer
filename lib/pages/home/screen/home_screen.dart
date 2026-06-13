import 'dart:math' show min;

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
import 'package:exchange_customer/pages/notifications/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────────────────────────────

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
        title: 'مرحباً ${UserSession.firstName ?? UserSession.fullName ?? 'مستخدم'}',
        centerTitle: false,
        fontColor: Colors.white,
        backgroundColor: isDark
            ? AppColors.kPrimaryColorDarkMode
            : AppColors.kPrimaryColor,
        actions: [
          BlocBuilder<NotificationsCubit, List<NotificationModel>>(
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
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                const SizedBox(height: 16),
                _buildSubmitButton(context),
                const SizedBox(height: 32),
                _buildAllRatesSection(context),
                const SizedBox(height: 32),
                _buildMyRequestsSection(context),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Rate Selector Card (gradient top section) ─────────────────────────────

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── header ───────────────────────────────────────────────────────
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
              const Spacer(),
              if (_fromCode.isNotEmpty && _toCode.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    '$_fromCode / $_toCode',
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          // ── currency selectors ────────────────────────────────────────────
          BlocBuilder<CurrenciesCubit, SigninState<List<CurrencyModel>>>(
            builder: (context, currState) {
              final currencies = currState.maybeWhen(
                success: (c) => c,
                orElse: () => <CurrencyModel>[],
              );
              if (_fromCode.isEmpty && currencies.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _fromCode = currencies[0].code ?? '';
                      _toCode = currencies.length > 1
                          ? (currencies[1].code ?? '')
                          : _fromCode;
                    });
                  }
                });
              }

              CurrencyModel? fromCurr;
              CurrencyModel? toCurr;
              for (final c in currencies) {
                if (c.code == _fromCode) fromCurr = c;
                if (c.code == _toCode) toCurr = c;
              }

              return Row(
                children: [
                  Expanded(
                    child: _CurrencyButton(
                      label: 'من',
                      currency: fromCurr,
                      code: _fromCode,
                      onTap: () =>
                          _showCurrencyPicker(context, true, currencies),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      final tmp = _fromCode;
                      _fromCode = _toCode;
                      _toCode = tmp;
                    }),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Icon(
                        Icons.swap_horiz_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _CurrencyButton(
                      label: 'إلى',
                      currency: toCurr,
                      code: _toCode,
                      onTap: () =>
                          _showCurrencyPicker(context, false, currencies),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          // ── rate display ──────────────────────────────────────────────────
          BlocBuilder<ExchangeRatesCubit, SigninState<List<ExchangeRateModel>>>(
            builder: (context, rateState) {
              final isLoading = rateState.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );
              final rates = rateState.maybeWhen(
                success: (r) => r,
                orElse: () => <ExchangeRateModel>[],
              );

              final currencies =
                  context.read<CurrenciesCubit>().state.maybeWhen(
                    success: (c) => c,
                    orElse: () => <CurrencyModel>[],
                  );
              final codeToId = {
                for (final c in currencies)
                  if (c.code != null && c.id != null) c.code!: c.id!,
              };

              ExchangeRateModel? rate;
              final fromId = codeToId[_fromCode];
              final toId = codeToId[_toCode];
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

              if (isLoading) return _rateShimmer();
              if (rate == null) return _rateNotFound();
              return _rateDisplay(rate);
            },
          ),
        ],
      ),
    );
  }

  Widget _rateNotFound() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.white.withValues(alpha: 0.5),
            size: 15,
          ),
          const SizedBox(width: 8),
          AppText(
            'لا يوجد سعر صرف لهذه العملتين',
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ],
      ),
    );
  }

  Widget _rateDisplay(ExchangeRateModel rate) {
    return Row(
      children: [
        Expanded(
          child: _RateBadge(
            label: 'سعر الشراء',
            value: rate.buyRate,
            color: const Color(0xFF34D399),
            icon: Icons.trending_up_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _RateBadge(
            label: 'سعر البيع',
            value: rate.sellRate,
            color: const Color(0xFFFCA5A5),
            icon: Icons.trending_down_rounded,
          ),
        ),
      ],
    );
  }

  Widget _rateShimmer() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  // ── Submit Button ─────────────────────────────────────────────────────────

  Widget _buildSubmitButton(BuildContext context) {
    return AppButton(
      text: 'طلب صرف جديد',
      onPressed: () => _showSubmitSheet(context),
      icon: Icons.send_rounded,
      padding: EdgeInsets.zero,
    );
  }

  // ── All Exchange Rates Section ────────────────────────────────────────────

  Widget _buildAllRatesSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          'أسعار الصرف المتاحة',
          Icons.list_alt_rounded,
          isDark,
        ),
        const SizedBox(height: 14),
        BlocBuilder<ExchangeRatesCubit, SigninState<List<ExchangeRateModel>>>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => _listShimmer(isDark),
              success: (rates) {
                if (rates.isEmpty) {
                  return _emptyState('لا توجد أسعار صرف متاحة حالياً');
                }
                return Column(
                  children: rates.asMap().entries.map((e) {
                    return _RateItem(
                      rate: e.value,
                      isDark: isDark,
                      isLast: e.key == rates.length - 1,
                      onTap: () {
                        final fc = e.value.fromCurrency?.code ?? '';
                        final tc = e.value.toCurrency?.code ?? '';
                        if (fc.isNotEmpty && tc.isNotEmpty) {
                          setState(() {
                            _fromCode = fc;
                            _toCode = tc;
                          });
                        }
                      },
                    );
                  }).toList(),
                );
              },
              error: (_) => _emptyState('تعذّر تحميل الأسعار'),
            );
          },
        ),
      ],
    );
  }

  // ── My Requests Section ───────────────────────────────────────────────────

  Widget _buildMyRequestsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _sectionHeader(
                'طلباتي الأخيرة',
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
                'عرض الكل',
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
              loading: () => _listShimmer(isDark, count: 2),
              success: (all) {
                final recent = all.take(5).toList();
                if (recent.isEmpty) {
                  return _emptyState('لم تقدّم أي طلبات بعد');
                }
                return Column(
                  children: recent.asMap().entries.map((e) {
                    return _RequestItem(
                      request: e.value,
                      isDark: isDark,
                      isLast: e.key == recent.length - 1,
                    );
                  }).toList(),
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
          margin: EdgeInsets.only(bottom: i < count - 1 ? 8 : 0),
          height: 68,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
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

  void _showCurrencyPicker(
    BuildContext context,
    bool isFrom,
    List<CurrencyModel> currencies,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CurrenciesCubit>(),
        child: _CurrencyPickerSheet(
          selectedCode: isFrom ? _fromCode : _toCode,
          onSelected: (currency) => setState(() {
            if (isFrom) {
              _fromCode = currency.code ?? '';
            } else {
              _toCode = currency.code ?? '';
            }
          }),
        ),
      ),
    );
  }

  void _showSubmitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ExchangeRequestsCubit>()),
          BlocProvider.value(value: context.read<CurrenciesCubit>()),
        ],
        child: const _SubmitSheet(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY BUTTON  (in gradient rate card)
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyButton extends StatelessWidget {
  final String label;
  final CurrencyModel? currency;
  final String code;
  final VoidCallback onTap;

  const _CurrencyButton({
    required this.label,
    required this.currency,
    required this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.11),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        ),
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
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    currency?.symbol ??
                        (code.isNotEmpty ? code[0] : '?'),
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        code.isEmpty ? '—' : code,
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      if (currency?.name != null)
                        AppText(
                          currency!.name!,
                          fontSize: 9,
                          color: Colors.white.withValues(alpha: 0.55),
                          fontWeight: FontWeight.w400,
                          maxLines: 1,
                        ),
                    ],
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
// RATE BADGE  (buy / sell display in the rate card)
// ─────────────────────────────────────────────────────────────────────────────

class _RateBadge extends StatelessWidget {
  final String label;
  final double? value;
  final Color color;
  final IconData icon;

  const _RateBadge({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  String _fmt(double v) =>
      v < 100 ? v.toStringAsFixed(3) : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 5),
              AppText(
                label,
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 6),
          AppText(
            value != null ? _fmt(value!) : '—',
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RATE ITEM  (in "All Exchange Rates" list)
// ─────────────────────────────────────────────────────────────────────────────

class _RateItem extends StatelessWidget {
  final ExchangeRateModel rate;
  final bool isDark;
  final bool isLast;
  final VoidCallback onTap;

  const _RateItem({
    required this.rate,
    required this.isDark,
    required this.isLast,
    required this.onTap,
  });

  String _fmt(double v) =>
      v < 100 ? v.toStringAsFixed(3) : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final fromCode = rate.fromCurrency?.code ?? '?';
    final toCode = rate.toCurrency?.code ?? '?';
    final fromSymbol =
        rate.fromCurrency?.symbol ??
        (fromCode.isNotEmpty ? fromCode[0] : '?');
    final toSymbol =
        rate.toCurrency?.symbol ?? (toCode.isNotEmpty ? toCode[0] : '?');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        child: Row(
          children: [
            // Overlapping currency symbols
            SizedBox(
              width: 60,
              height: 40,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.kPrimaryColor, Color(0xFF047857)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: AppText(
                      fromSymbol,
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Positioned(
                    left: 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.kCardDark : Colors.white,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        toSymbol,
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(
                        fromCode,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 13,
                          color: AppColors.kGreyColor,
                        ),
                      ),
                      AppText(toCode, fontSize: 14, fontWeight: FontWeight.w700),
                    ],
                  ),
                  if (rate.fromCurrency?.name != null)
                    AppText(
                      rate.fromCurrency!.name!,
                      fontSize: 10,
                      color: AppColors.kGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const AppText(
                      'شراء  ',
                      fontSize: 10,
                      color: AppColors.kGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                    AppText(
                      _fmt(rate.buyRate ?? 0),
                      fontSize: 13,
                      color: AppColors.kSuccessColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const AppText(
                      'بيع   ',
                      fontSize: 10,
                      color: AppColors.kGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                    AppText(
                      _fmt(rate.sellRate ?? 0),
                      fontSize: 13,
                      color: AppColors.kRedColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
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
// REQUEST ITEM  (in "My Requests" list)
// ─────────────────────────────────────────────────────────────────────────────

class _RequestItem extends StatelessWidget {
  final ExchangeRequestModel request;
  final bool isDark;
  final bool isLast;

  const _RequestItem({
    required this.request,
    required this.isDark,
    required this.isLast,
  });

  static const _statusConfig = {
    0: (
      icon: Icons.hourglass_empty_rounded,
      color: Color(0xFFF59E0B),
      label: 'معلّق',
    ),
    1: (
      icon: Icons.check_circle_rounded,
      color: AppColors.kSuccessColor,
      label: 'مقبول',
    ),
    2: (
      icon: Icons.cancel_rounded,
      color: AppColors.kRedColor,
      label: 'مرفوض',
    ),
    3: (
      icon: Icons.pause_circle_rounded,
      color: AppColors.kGreyColor,
      label: 'موقوف',
    ),
  };

  String _fmt(double? v) {
    if (v == null) return '—';
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}م';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}ك';
    return v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
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

  @override
  Widget build(BuildContext context) {
    final cfg = _statusConfig[request.status] ??
        (
          icon: Icons.help_outline_rounded,
          color: AppColors.kGreyColor,
          label: '—',
        );

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Status icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: cfg.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(cfg.icon, color: cfg.color, size: 24),
          ),
          const SizedBox(width: 12),
          // Currency pair + amount
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _CodeChip(
                      code: request.fromCurrency?.code ?? '—',
                      color: AppColors.kRedColor,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 12,
                        color: AppColors.kGreyColor,
                      ),
                    ),
                    _CodeChip(
                      code: request.toCurrency?.code ?? '—',
                      color: AppColors.kSuccessColor,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                AppText(
                  '${_fmt(request.amount)} ${request.fromCurrency?.code ?? ''}',
                  fontSize: 12,
                  color: AppColors.kGreyColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          // Status + date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: cfg.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                  cfg.label,
                  fontSize: 10,
                  color: cfg.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              AppText(
                _fmtDate(request.createdAt ?? request.createdOn),
                fontSize: 10,
                color: AppColors.kGreyColor.withValues(alpha: 0.65),
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CODE CHIP
// ─────────────────────────────────────────────────────────────────────────────

class _CodeChip extends StatelessWidget {
  final String code;
  final Color color;

  const _CodeChip({required this.code, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: AppText(
        code,
        fontSize: 10,
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUBMIT REQUEST SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _SubmitSheet extends StatefulWidget {
  const _SubmitSheet();

  @override
  State<_SubmitSheet> createState() => _SubmitSheetState();
}

class _SubmitSheetState extends State<_SubmitSheet> {
  CurrencyModel? _fromCurrency;
  CurrencyModel? _toCurrency;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExchangeRequestsCubit>();

    return BlocConsumer<ExchangeRequestsCubit, SigninState<List<ExchangeRequestModel>>>(
      listenWhen: (p, c) =>
          p.maybeWhen(loading: () => true, orElse: () => false),
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            AppSnackbar.showSuccess(context, 'تم تقديم طلب الصرف بنجاح');
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

        return _BottomSheetContainer(
          title: 'طلب صرف جديد',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Currency pair selector
              Row(
                children: [
                  Expanded(
                    child: _CurrencySelector(
                      label: 'من عملة',
                      currency: _fromCurrency,
                      onTap: () => _pickCurrency(context, true),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      final tmp = _fromCurrency;
                      _fromCurrency = _toCurrency;
                      _toCurrency = tmp;
                    }),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.kPrimaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.swap_horiz_rounded,
                        color: AppColors.kPrimaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _CurrencySelector(
                      label: 'إلى عملة',
                      currency: _toCurrency,
                      onTap: () => _pickCurrency(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Amount + notes form
              Form(
                key: cubit.formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      label: 'المبلغ',
                      controller: cubit.amountController,
                      icon: Icons.attach_money_rounded,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'المبلغ مطلوب';
                        if (double.tryParse(v) == null) {
                          return 'رقم غير صالح';
                        }
                        if ((double.tryParse(v) ?? 0) <= 0) {
                          return 'يجب أن يكون المبلغ أكبر من صفر';
                        }
                        return null;
                      },
                    ),
                    AppTextFormField(
                      label: 'ملاحظات (اختياري)',
                      controller: cubit.notesController,
                      icon: Icons.notes_rounded,
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      text: 'تقديم الطلب',
                      onPressed: () => _submit(context, cubit),
                      isLoading: isLoading,
                      icon: Icons.send_rounded,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit(BuildContext context, ExchangeRequestsCubit cubit) {
    if (_fromCurrency == null || _toCurrency == null) {
      AppSnackbar.showError(context, 'يرجى اختيار العملتين');
      return;
    }
    if (_fromCurrency!.id == _toCurrency!.id) {
      AppSnackbar.showError(context, 'لا يمكن اختيار نفس العملة');
      return;
    }
    if (!cubit.validateForm()) return;
    cubit.submitRequest(
      fromCurrencyId: _fromCurrency!.id!,
      toCurrencyId: _toCurrency!.id!,
    );
  }

  void _pickCurrency(BuildContext context, bool isFrom) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CurrenciesCubit>(),
        child: _CurrencyPickerSheet(
          selectedCode: isFrom
              ? (_fromCurrency?.code ?? '')
              : (_toCurrency?.code ?? ''),
          onSelected: (currency) => setState(() {
            if (isFrom) {
              _fromCurrency = currency;
            } else {
              _toCurrency = currency;
            }
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY SELECTOR  (in submit sheet)
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencySelector extends StatelessWidget {
  final String label;
  final CurrencyModel? currency;
  final VoidCallback onTap;

  const _CurrencySelector({
    required this.label,
    required this.currency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = currency != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.kPrimaryColor.withValues(alpha: 0.5)
                : AppColors.kGreyColor.withValues(alpha: 0.2),
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            if (selected)
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.kPrimaryColor, Color(0xFF047857)],
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: AppText(
                  currency!.symbol ?? (currency!.code?.isNotEmpty == true
                      ? currency!.code![0]
                      : '?'),
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              )
            else
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.kGreyColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.kGreyColor,
                  size: 18,
                ),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    label,
                    fontSize: 9,
                    color: AppColors.kGreyColor,
                    fontWeight: FontWeight.w500,
                  ),
                  AppText(
                    selected ? (currency!.code ?? '') : 'اختر',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? null
                        : AppColors.kGreyColor,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.kGreyColor.withValues(alpha: 0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY PICKER SHEET  (read-only — no add/edit for customers)
// ─────────────────────────────────────────────────────────────────────────────

class _CurrencyPickerSheet extends StatefulWidget {
  final String selectedCode;
  final ValueChanged<CurrencyModel> onSelected;

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
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.kGreyColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const AppText('اختر العملة', fontSize: 16, fontWeight: FontWeight.w700),
          const SizedBox(height: 14),
          // Search
          TextField(
            onChanged: (v) =>
                setState(() => _query = v.toLowerCase().trim()),
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
          ),
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
                  maxHeight: min(filtered.length * 68.0 + 8, 320),
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
                  itemBuilder: (_, i) {
                    final c = filtered[i];
                    final isSelected = c.code == widget.selectedCode;
                    final isActive = c.isActive ?? false;

                    return Material(
                      color: isSelected
                          ? AppColors.kPrimaryColor.withValues(alpha: 0.06)
                          : Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          widget.onSelected(c);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isActive
                                        ? [
                                            AppColors.kPrimaryColor,
                                            const Color(0xFF047857),
                                          ]
                                        : [
                                            AppColors.kGreyColor,
                                            const Color(0xFF94A3B8),
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: AppText(
                                  c.symbol ?? '',
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
                                      c.code ?? '',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    AppText(
                                      c.name ?? '',
                                      fontSize: 11,
                                      color: AppColors.kGreyColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.kPrimaryColor,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED BOTTOM SHEET CONTAINER
// ─────────────────────────────────────────────────────────────────────────────

class _BottomSheetContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _BottomSheetContainer({required this.title, required this.child});

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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.kPrimaryColor, Color(0xFF047857)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.currency_exchange_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              AppText(title, fontSize: 16, fontWeight: FontWeight.w700),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
