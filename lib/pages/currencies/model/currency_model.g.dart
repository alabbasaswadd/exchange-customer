// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyModel _$CurrencyModelFromJson(Map<String, dynamic> json) =>
    CurrencyModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      symbol: json['symbol'] as String?,
      isActive: json['isActive'] as bool?,
      createdOn: json['createdOn'] as String?,
    );

Map<String, dynamic> _$CurrencyModelToJson(CurrencyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'symbol': instance.symbol,
      'isActive': instance.isActive,
      'createdOn': instance.createdOn,
    };
