import 'package:exchange_customer/core/constants/model/error_model.dart';
import 'package:exchange_customer/pages/exchange_requests/model/exchange_request_model.dart';

class ExchangeRequestListResponseModel {
  final bool? succeeded;
  final List<ExchangeRequestModel>? data;
  final ErrorModel? error;

  const ExchangeRequestListResponseModel({
    this.succeeded,
    this.data,
    this.error,
  });

  factory ExchangeRequestListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => ExchangeRequestListResponseModel(
    succeeded: json['succeeded'] as bool?,
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => ExchangeRequestModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    error: json['error'] == null
        ? null
        : ErrorModel.fromJson(json['error'] as Map<String, dynamic>),
  );
}
