// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRateModel _$ExchangeRateModelFromJson(Map<String, dynamic> json) =>
    ExchangeRateModel(
      id: json['id'] as String?,
      fromCurrencyId: json['fromCurrencyId'] as String?,
      toCurrencyId: json['toCurrencyId'] as String?,
      buyRate: (json['buyRate'] as num?)?.toDouble(),
      sellRate: (json['sellRate'] as num?)?.toDouble(),
      commissionPercent: (json['commissionPercent'] as num?)?.toInt(),
      isActive: json['isActive'] as bool?,
      createdOn: json['createdOn'] as String?,
      fromCurrency: json['fromCurrency'] == null
          ? null
          : CurrencyModel.fromJson(
              json['fromCurrency'] as Map<String, dynamic>,
            ),
      toCurrency: json['toCurrency'] == null
          ? null
          : CurrencyModel.fromJson(json['toCurrency'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExchangeRateModelToJson(ExchangeRateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromCurrencyId': instance.fromCurrencyId,
      'toCurrencyId': instance.toCurrencyId,
      'buyRate': instance.buyRate,
      'sellRate': instance.sellRate,
      'commissionPercent': instance.commissionPercent,
      'isActive': instance.isActive,
      'createdOn': instance.createdOn,
      'fromCurrency': instance.fromCurrency,
      'toCurrency': instance.toCurrency,
    };
