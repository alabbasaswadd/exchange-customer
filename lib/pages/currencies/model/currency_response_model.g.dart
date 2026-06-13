// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyResponseModel _$CurrencyResponseModelFromJson(
  Map<String, dynamic> json,
) => CurrencyResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map(
        (e) => e == null
            ? null
            : CurrencyModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  error: json['error'] == null
      ? null
      : ErrorModel.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CurrencyResponseModelToJson(
  CurrencyResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'error': instance.error,
};
