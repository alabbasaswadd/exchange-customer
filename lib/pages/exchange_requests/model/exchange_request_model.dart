import 'package:exchange_customer/pages/auth/signin/model/user_model.dart';
import 'package:exchange_customer/pages/currencies/model/currency_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_request_model.g.dart';

@JsonSerializable()
class ExchangeRequestModel {
  final String? id;
  final String? requestNumber;
  final String? userId;
  final String? fromCurrencyId;
  final String? toCurrencyId;
  final double? amount;
  final double? exchangeRate;
  final double? appliedRate;
  final double? commissionPercent;
  final double? commissionAmount;
  final double? finalAmount;
  final double? paymentMethod;
  final int? status;
  final String? notes;
  final String? createdOn;
  final String? createdAt;
  final String? paymentDeadline;
  final UserModel? user;
  final CurrencyModel? fromCurrency;
  final CurrencyModel? toCurrency;

  const ExchangeRequestModel({
    this.id,
    this.requestNumber,
    this.userId,
    this.fromCurrencyId,
    this.toCurrencyId,
    this.amount,
    this.exchangeRate,
    this.appliedRate,
    this.commissionPercent,
    this.commissionAmount,
    this.finalAmount,
    this.paymentMethod,
    this.status,
    this.notes,
    this.createdOn,
    this.createdAt,
    this.paymentDeadline,
    this.user,
    this.fromCurrency,
    this.toCurrency,
  });
  factory ExchangeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExchangeRequestModelToJson(this);
}
