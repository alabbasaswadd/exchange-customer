import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rate_request_model.g.dart';

@JsonSerializable()
class ExchangeRateRequestModel {
  final double? buyRate;
  final double? sellRate;
  final int? commissionPercent;
  final bool? isActive;

  ExchangeRateRequestModel({
    this.buyRate,
    this.sellRate,
    this.commissionPercent,
    this.isActive,
  });

  factory ExchangeRateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExchangeRateRequestModelToJson(this);
}
