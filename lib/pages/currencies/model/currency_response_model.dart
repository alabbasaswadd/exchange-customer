import 'package:exchange_customer/core/constants/model/error_model.dart';
import 'package:exchange_customer/pages/currencies/model/currency_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_response_model.g.dart';

@JsonSerializable()
class CurrencyResponseModel {
  final bool? succeeded;
  final List<CurrencyModel?>? data;
  final ErrorModel? error;

  CurrencyResponseModel({this.succeeded, this.data, this.error});

  factory CurrencyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyResponseModelFromJson(json);

  Map<String, dynamic> toJson() {
    return _$CurrencyResponseModelToJson(this);
  }
}
