// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRateRequestModel _$ExchangeRateRequestModelFromJson(
  Map<String, dynamic> json,
) => ExchangeRateRequestModel(
  buyRate: (json['buyRate'] as num?)?.toDouble(),
  sellRate: (json['sellRate'] as num?)?.toDouble(),
  commissionPercent: (json['commissionPercent'] as num?)?.toInt(),
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$ExchangeRateRequestModelToJson(
  ExchangeRateRequestModel instance,
) => <String, dynamic>{
  'buyRate': instance.buyRate,
  'sellRate': instance.sellRate,
  'commissionPercent': instance.commissionPercent,
  'isActive': instance.isActive,
};
