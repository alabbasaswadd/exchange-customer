import 'package:exchange_customer/core/constants/base_cubit.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:exchange_customer/pages/exchange_requests/api/exchange_requests_api.dart';
import 'package:exchange_customer/pages/exchange_requests/model/confirm_payment_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/create_exchange_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_filter_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_request_model.dart';
import 'package:flutter/material.dart';

class ExchangeRequestsCubit
    extends BaseCubit<SigninState<List<ExchangeRequestModel>>> {
  final ExchangeRequestsApi api;

  ExchangeRequestsCubit(this.api) : super(const SigninState.initial());

  List<ExchangeRequestModel> _all = [];
  ExchangeFilterModel _filter = const ExchangeFilterModel();
  int? _statusFilter;

  ExchangeFilterModel get filter => _filter;
  int? get statusFilter => _statusFilter;

  List<ExchangeRequestModel> get acceptedRequests =>
      _all.where((r) => r.status == 1).toList();

  final TextEditingController amountController = TextEditingController();

  void setFilter(int? status) {
    _statusFilter = status;
    _emitFiltered();
  }

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

  void applyFilter(ExchangeFilterModel filter) {
    _filter = filter;
    _emitFiltered();
  }

  void _emitFiltered() {
    var list = List<ExchangeRequestModel>.from(_all);

    if (_statusFilter != null) {
      list = list.where((r) => r.status == _statusFilter).toList();
    } else if (_filter.statuses.isNotEmpty) {
      list = list.where((r) => _filter.statuses.contains(r.status)).toList();
    }

    if (_filter.dateFrom != null) {
      list = list.where((r) {
        final d = _parseDate(r.createdAt ?? r.createdOn);
        return d != null && !d.isBefore(_filter.dateFrom!);
      }).toList();
    }

    if (_filter.dateTo != null) {
      final endOfDay = DateTime(
        _filter.dateTo!.year,
        _filter.dateTo!.month,
        _filter.dateTo!.day,
        23,
        59,
        59,
      );
      list = list.where((r) {
        final d = _parseDate(r.createdAt ?? r.createdOn);
        return d != null && !d.isAfter(endOfDay);
      }).toList();
    }

    if (_filter.minAmount != null) {
      list = list.where((r) => (r.amount ?? 0) >= _filter.minAmount!).toList();
    }

    if (_filter.maxAmount != null) {
      list = list.where((r) => (r.amount ?? 0) <= _filter.maxAmount!).toList();
    }

    emit(SigninState.success(list));
  }

  DateTime? _parseDate(String? d) {
    if (d == null) return null;
    try {
      return DateTime.parse(d);
    } catch (_) {
      return null;
    }
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
        ),
      ),
      onSuccess: (_) async {
        amountController.clear();
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

  Future<void> cancelRequest(String id, String? note) async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.cancelRequest(id, note),
      onSuccess: (_) async => fetchRequests(),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  Future<void> confirmPayment(String id, ConfirmPaymentModel data) async {
    await executeApi(
      onLoading: () => emit(const SigninState.loading()),
      request: () => api.confirmPayment(id, data),
      onSuccess: (_) async => fetchRequests(),
      onError: (message) => emit(SigninState.error(message)),
    );
  }

  Future<void> submitTransferNumber(String id, String externalTransactionId) =>
      confirmPayment(
        id,
        ConfirmPaymentModel(transactionNumber: externalTransactionId),
      );

  @override
  Future<void> close() {
    disposeControllers([amountController]);
    return super.close();
  }
}
