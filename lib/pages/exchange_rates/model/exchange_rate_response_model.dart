import 'package:exchange_customer/core/constants/model/error_model.dart';
import 'package:exchange_customer/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate_response_model.g.dart';

@JsonSerializable()
class ExchangeRateResponseModel {
  final bool? succeeded;
  final ExchangeRateModel? data;
  final ErrorModel? error;

  ExchangeRateResponseModel({this.succeeded, this.data, this.error});

  factory ExchangeRateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateResponseModelFromJson(json);

  Map<String, dynamic> toJson() {
    return _$ExchangeRateResponseModelToJson(this);
  }
}
