// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRequestModel _$ExchangeRequestModelFromJson(
  Map<String, dynamic> json,
) => ExchangeRequestModel(
  id: json['id'] as String?,
  requestNumber: json['requestNumber'] as String?,
  userId: json['userId'] as String?,
  fromCurrencyId: json['fromCurrencyId'] as String?,
  toCurrencyId: json['toCurrencyId'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  exchangeRate: (json['exchangeRate'] as num?)?.toDouble(),
  appliedRate: (json['appliedRate'] as num?)?.toDouble(),
  commissionPercent: (json['commissionPercent'] as num?)?.toDouble(),
  commissionAmount: (json['commissionAmount'] as num?)?.toDouble(),
  finalAmount: (json['finalAmount'] as num?)?.toDouble(),
  paymentMethod: (json['paymentMethod'] as num?)?.toDouble(),
  status: (json['status'] as num?)?.toInt(),
  notes: json['notes'] as String?,
  createdOn: json['createdOn'] as String?,
  createdAt: json['createdAt'] as String?,
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  fromCurrency: json['fromCurrency'] == null
      ? null
      : CurrencyModel.fromJson(json['fromCurrency'] as Map<String, dynamic>),
  toCurrency: json['toCurrency'] == null
      ? null
      : CurrencyModel.fromJson(json['toCurrency'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ExchangeRequestModelToJson(
  ExchangeRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'requestNumber': instance.requestNumber,
  'userId': instance.userId,
  'fromCurrencyId': instance.fromCurrencyId,
  'toCurrencyId': instance.toCurrencyId,
  'amount': instance.amount,
  'exchangeRate': instance.exchangeRate,
  'appliedRate': instance.appliedRate,
  'commissionPercent': instance.commissionPercent,
  'commissionAmount': instance.commissionAmount,
  'finalAmount': instance.finalAmount,
  'paymentMethod': instance.paymentMethod,
  'status': instance.status,
  'notes': instance.notes,
  'createdOn': instance.createdOn,
  'createdAt': instance.createdAt,
  'user': instance.user,
  'fromCurrency': instance.fromCurrency,
  'toCurrency': instance.toCurrency,
};
