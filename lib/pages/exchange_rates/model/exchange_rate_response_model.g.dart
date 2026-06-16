// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRateResponseModel _$ExchangeRateResponseModelFromJson(
  Map<String, dynamic> json,
) => ExchangeRateResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ExchangeRateModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  error: json['error'] == null
      ? null
      : ErrorModel.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ExchangeRateResponseModelToJson(
  ExchangeRateResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'error': instance.error,
};
