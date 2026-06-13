import 'package:exchange_customer/pages/currencies/model/currency_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rate_model.g.dart';

@JsonSerializable()
class ExchangeRateModel {
  final String? id;
  final String? fromCurrencyId;
  final String? toCurrencyId;
  final double? buyRate;
  final double? sellRate;
  final int? commissionPercent;
  final bool? isActive;
  final String? createdOn;
  final CurrencyModel? fromCurrency;
  final CurrencyModel? toCurrency;

  const ExchangeRateModel({
    this.id,
    this.fromCurrencyId,
    this.toCurrencyId,
    this.buyRate,
    this.sellRate,
    this.commissionPercent,
    this.isActive,
    this.createdOn,
    this.fromCurrency,
    this.toCurrency,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExchangeRateModelToJson(this);
}
