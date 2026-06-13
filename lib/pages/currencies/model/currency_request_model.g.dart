// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyRequestModel _$CurrencyRequestModelFromJson(
  Map<String, dynamic> json,
) => CurrencyRequestModel(
  name: json['name'] as String,
  code: json['code'] as String,
  symbol: json['symbol'] as String,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$CurrencyRequestModelToJson(
  CurrencyRequestModel instance,
) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
  'symbol': instance.symbol,
  'isActive': instance.isActive,
};
