import 'package:exchange_customer/core/constants/base_cubit.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_customer/pages/currencies/api/currencies_api.dart';
import 'package:exchange_customer/pages/currencies/model/currency_model.dart';
import 'package:exchange_customer/pages/currencies/model/currency_request_model.dart';
import 'package:flutter/material.dart';

class CurrenciesCubit extends BaseCubit<SigninState<List<CurrencyModel>>> {
  final CurrenciesApi api;

  CurrenciesCubit(this.api) : super(const SigninState.initial());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController symbolController = TextEditingController();
  bool isActiveValue = true;

  Future<void> fetchCurrencies() async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.getCurrencies(),
      onSuccess: (data) async {
        emit(SigninState.success(data));
      },
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  Future<void> addCurrency() async {
    if (!validateForm()) return;

    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.addCurrency(
        CurrencyRequestModel(
          name: nameController.text.trim(),
          code: codeController.text.trim().toUpperCase(),
          symbol: symbolController.text.trim(),
          isActive: isActiveValue,
        ),
      ),
      onSuccess: (_) async => fetchCurrencies(),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  Future<void> updateCurrency(String id) async {
    if (!validateForm()) return;

    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.updateCurrency(
        id,
        CurrencyRequestModel(
          name: nameController.text.trim(),
          code: codeController.text.trim().toUpperCase(),
          symbol: symbolController.text.trim(),
          isActive: isActiveValue,
        ),
      ),
      onSuccess: (_) async => fetchCurrencies(),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  Future<void> deleteCurrency(String id) async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.deleteCurrency(id),
      onSuccess: (_) async => fetchCurrencies(),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  void prepareForAdd() {
    nameController.clear();
    codeController.clear();
    symbolController.clear();
    isActiveValue = true;
  }

  void prepareForEdit(CurrencyModel currency) {
    nameController.text = currency.name ?? '';
    codeController.text = currency.code ?? '';
    symbolController.text = currency.symbol ?? '';
    isActiveValue = currency.isActive ?? true;
  }

  @override
  Future<void> close() {
    disposeControllers([nameController, codeController, symbolController]);
    return super.close();
  }
}
