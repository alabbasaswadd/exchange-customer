// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_request_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRequestResponseModel _$ExchangeRequestResponseModelFromJson(
  Map<String, dynamic> json,
) => ExchangeRequestResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: json['data'] == null
      ? null
      : ExchangeRequestModel.fromJson(json['data'] as Map<String, dynamic>),
  error: json['error'] == null
      ? null
      : ErrorModel.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ExchangeRequestResponseModelToJson(
  ExchangeRequestResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'error': instance.error,
};
