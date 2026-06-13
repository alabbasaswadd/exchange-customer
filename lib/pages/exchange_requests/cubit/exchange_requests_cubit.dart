import 'package:exchange_customer/core/constants/base_cubit.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_customer/pages/exchange_requests/api/exchange_requests_api.dart';
import 'package:exchange_customer/pages/exchange_requests/model/create_exchange_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_request_model.dart';
import 'package:flutter/material.dart';

class ExchangeRequestsCubit
    extends BaseCubit<SigninState<List<ExchangeRequestModel>>> {
  final ExchangeRequestsApi api;

  ExchangeRequestsCubit(this.api) : super(const SigninState.initial());

  List<ExchangeRequestModel> _all = [];
  int? statusFilter;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  Future<void> fetchRequests() async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.getRequests(),
      onSuccess: (data) async {
        _all = data;
        _emitFiltered();
      },
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  void setFilter(int? status) {
    statusFilter = status;
    _emitFiltered();
  }

  void _emitFiltered() {
    final filtered = statusFilter == null
        ? List<ExchangeRequestModel>.from(_all)
        : _all.where((r) => r.status == statusFilter).toList();
    emit(SigninState.success(filtered));
  }

  Future<void> submitRequest({
    required String fromCurrencyId,
    required String toCurrencyId,
  }) async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.createRequest(
        CreateExchangeRequestModel(
          fromCurrencyId: fromCurrencyId,
          toCurrencyId: toCurrencyId,
          amount: double.parse(amountController.text),
          notes: notesController.text.trim().isEmpty
              ? null
              : notesController.text.trim(),
        ),
      ),
      onSuccess: (_) async {
        amountController.clear();
        notesController.clear();
        await fetchRequests();
      },
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  Future<void> updateRequest(
    String id,
    ExchangeRequestRequestModel data,
  ) async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.updateRequest(id, data),
      onSuccess: (_) async => fetchRequests(),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  // Future<void> rejectRequest(String id) async {
  //   await executeApi(
  //     onLoading: () => emit(const SigninState.loading()),
  //     request: () => api.rejectRequest(id),
  //     onSuccess: (_) async => fetchRequests(),
  //     onError: (message) => emit(SigninState.error(message)),
  //   );
  // }

  // Future<void> suspendRequest(String id) async {
  //   await executeApi(
  //     onLoading: () => emit(const SigninState.loading()),
  //     request: () => api.suspendRequest(id),
  //     onSuccess: (_) async => fetchRequests(),
  //     onError: (message) => emit(SigninState.error(message)),
  //   );
  // }

  @override
  Future<void> close() {
    disposeControllers([amountController, notesController]);
    return super.close();
  }
}
