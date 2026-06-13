import 'package:exchange_customer/core/constants/base_cubit.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_customer/pages/exchange_rates/api/exchange_rates_api.dart';
import 'package:exchange_customer/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:flutter/material.dart';

class ExchangeRatesCubit
    extends BaseCubit<SigninState<List<ExchangeRateModel>>> {
  final ExchangeRatesApi api;

  ExchangeRatesCubit(this.api) : super(const SigninState.initial());

  final TextEditingController buyRateController = TextEditingController();
  final TextEditingController sellRateController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();

  Future<void> fetchRates() async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.getRates(),
      onSuccess: (data) async => emit(SigninState.success(data)),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  @override
  Future<void> close() {
    disposeControllers([
      buyRateController,
      sellRateController,
      commissionController,
    ]);
    return super.close();
  }
}
