// import 'package:exchange_customer/core/components/app_button.dart';
// import 'package:exchange_customer/core/components/app_snackbar.dart';
// import 'package:exchange_customer/core/components/app_text.dart';
// import 'package:exchange_customer/core/components/app_text_form_field.dart';
// import 'package:exchange_customer/core/components/shimmer_widgets.dart';
// import 'package:exchange_customer/core/constants/colors.dart';
// import 'package:exchange_customer/l10n/app_localizations.dart';
// import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
// import 'package:exchange_customer/pages/exchange_rates/cubit/exchange_rates_cubit.dart';
// import 'package:exchange_customer/pages/exchange_rates/model/exchange_rate_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ExchangeRatesScreen extends StatefulWidget {
//   const ExchangeRatesScreen({super.key});

//   @override
//   State<ExchangeRatesScreen> createState() => _ExchangeRatesScreenState();
// }

// class _ExchangeRatesScreenState extends State<ExchangeRatesScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ExchangeRatesCubit>().fetchRates();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     return BlocConsumer<ExchangeRatesCubit, SigninState<List<ExchangeRateModel>>>(
//       listenWhen: (prev, curr) =>
//           prev.maybeWhen(loading: () => true, orElse: () => false),
//       listener: (context, state) {
//         state.maybeWhen(
//           error: (msg) => AppSnackbar.showError(context, msg),
//           orElse: () {},
//         );
//       },
//       builder: (context, state) {
//         return RefreshIndicator(
//           color: AppColors.kPrimaryColor,
//           onRefresh: () => context.read<ExchangeRatesCubit>().fetchRates(),
//           child: state.when(
//             initial: () => const SizedBox(),
//             loading: () => _buildShimmer(),
//             success: (rates) => rates.isEmpty
//                 ? _buildEmpty(t)
//                 : _buildList(rates, t),
//             error: (msg) => _buildError(msg, t),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildShimmer() {
//     return ListView.separated(
//       padding: const EdgeInsets.all(16),
//       itemCount: 5,
//       separatorBuilder: (_, __) => const SizedBox(height: 12),
//       itemBuilder: (_, __) => ShimmerWidget.rectangular(height: 100),
//     );
//   }

//   Widget _buildEmpty(AppLocalizations t) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.currency_exchange_rounded,
//             size: 72,
//             color: AppColors.kGreyColor.withOpacity(0.4),
//           ),
//           const SizedBox(height: 16),
//           AppText(
//             t.no_exchange_rates,
//             fontSize: 16,
//             color: AppColors.kGreyColor,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildError(String message, AppLocalizations t) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline_rounded,
//               size: 64,
//               color: AppColors.kRedColor.withOpacity(0.6),
//             ),
//             const SizedBox(height: 16),
//             AppText(
//               message,
//               fontSize: 14,
//               color: AppColors.kGreyColor,
//               textAlign: TextAlign.center,
//               maxLines: 3,
//             ),
//             const SizedBox(height: 24),
//             AppButton(
//               text: t.retry,
//               icon: Icons.refresh_rounded,
//               onPressed: () => context.read<ExchangeRatesCubit>().fetchRates(),
//               padding: EdgeInsets.zero,
//               height: 44,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildList(List<ExchangeRateModel> rates, AppLocalizations t) {
//     return ListView.separated(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
//       itemCount: rates.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 12),
//       itemBuilder: (_, index) => _RateCard(
//         rate: rates[index],
//         onEdit: () => _showEditSheet(context, rates[index], t),
//       ),
//     );
//   }

//   void _showEditSheet(
//     BuildContext context,
//     ExchangeRateModel rate,
//     AppLocalizations t,
//   ) {
//     context.read<ExchangeRatesCubit>().prepareForEdit(rate);
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (sheetCtx) => BlocProvider.value(
//         value: context.read<ExchangeRatesCubit>(),
//         child: _EditRateSheet(rate: rate),
//       ),
//     );
//   }
// }

// class _RateCard extends StatelessWidget {
//   final ExchangeRateModel rate;
//   final VoidCallback onEdit;

//   const _RateCard({required this.rate, required this.onEdit});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.kCardDark : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           if (!isDark)
//             BoxShadow(
//               color: Colors.black.withOpacity(0.07),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//         ],
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           _CurrencyBadge(
//             from: rate.fromCurrencyCode ?? '—',
//             to: rate.toCurrencyCode ?? '—',
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   '${rate.fromCurrencyName ?? ''} → ${rate.toCurrencyName ?? ''}',
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     _RateChip(
//                       label: 'شراء',
//                       value: rate.buyRate?.toStringAsFixed(2) ?? '—',
//                       color: AppColors.kSuccessColor,
//                     ),
//                     const SizedBox(width: 8),
//                     _RateChip(
//                       label: 'بيع',
//                       value: rate.sellRate?.toStringAsFixed(2) ?? '—',
//                       color: AppColors.kRedColor,
//                     ),
//                   ],
//                 ),
//                 if (rate.updatedAt != null) ...[
//                   const SizedBox(height: 6),
//                   AppText(
//                     rate.updatedAt!,
//                     fontSize: 11,
//                     color: AppColors.kGreyColor,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           IconButton(
//             onPressed: onEdit,
//             icon: const Icon(Icons.edit_rounded),
//             color: AppColors.kPrimaryColor,
//             tooltip: 'تعديل',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CurrencyBadge extends StatelessWidget {
//   final String from;
//   final String to;

//   const _CurrencyBadge({required this.from, required this.to});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 60,
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
//       decoration: BoxDecoration(
//         color: AppColors.kPrimaryColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AppText(from, fontSize: 11, color: AppColors.kPrimaryColor),
//           const Icon(
//             Icons.swap_vert_rounded,
//             size: 14,
//             color: AppColors.kPrimaryColor,
//           ),
//           AppText(to, fontSize: 11, color: AppColors.kPrimaryColor),
//         ],
//       ),
//     );
//   }
// }

// class _RateChip extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;

//   const _RateChip({
//     required this.label,
//     required this.value,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AppText(label, fontSize: 11, color: color),
//           const SizedBox(width: 4),
//           AppText(
//             value,
//             fontSize: 12,
//             color: color,
//             fontWeight: FontWeight.w700,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _EditRateSheet extends StatelessWidget {
//   final ExchangeRateModel rate;

//   const _EditRateSheet({required this.rate});

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     final cubit = context.read<ExchangeRatesCubit>();

//     return BlocConsumer<ExchangeRatesCubit, SigninState<List<ExchangeRateModel>>>(
//       listenWhen: (prev, curr) =>
//           prev.maybeWhen(loading: () => true, orElse: () => false),
//       listener: (context, state) {
//         state.maybeWhen(
//           success: (_) => Navigator.pop(context),
//           error: (msg) => AppSnackbar.showError(context, msg),
//           orElse: () {},
//         );
//       },
//       builder: (context, state) {
//         final isLoading =
//             state.maybeWhen(loading: () => true, orElse: () => false);
//         return Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).scaffoldBackgroundColor,
//             borderRadius:
//                 const BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           padding: EdgeInsets.only(
//             top: 24,
//             left: 24,
//             right: 24,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//           ),
//           child: Form(
//             key: cubit.formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: AppColors.kGreyColor.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 AppText(
//                   '${t.update_rate}: ${rate.fromCurrencyCode} → ${rate.toCurrencyCode}',
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 const SizedBox(height: 20),
//                 AppTextFormField(
//                   label: t.buy_rate,
//                   controller: cubit.buyRateController,
//                   icon: Icons.trending_down_rounded,
//                   keyboardType:
//                       const TextInputType.numberWithOptions(decimal: true),
//                   textInputAction: TextInputAction.next,
//                   validator: (v) {
//                     if (v == null || v.isEmpty) return t.rate_required;
//                     if (double.tryParse(v) == null) return t.invalid_rate;
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 AppTextFormField(
//                   label: t.sell_rate,
//                   controller: cubit.sellRateController,
//                   icon: Icons.trending_up_rounded,
//                   keyboardType:
//                       const TextInputType.numberWithOptions(decimal: true),
//                   textInputAction: TextInputAction.done,
//                   validator: (v) {
//                     if (v == null || v.isEmpty) return t.rate_required;
//                     if (double.tryParse(v) == null) return t.invalid_rate;
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: AppButton(
//                     text: t.save_rates,
//                     icon: Icons.save_rounded,
//                     isLoading: isLoading,
//                     onPressed: () => cubit.updateRate(rate.id!),
//                     padding: EdgeInsets.zero,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
