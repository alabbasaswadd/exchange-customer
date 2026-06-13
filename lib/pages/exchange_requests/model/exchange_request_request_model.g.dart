// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_request_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRequestRequestModel _$ExchangeRequestRequestModelFromJson(
  Map<String, dynamic> json,
) => ExchangeRequestRequestModel(
  newStatus: (json['newStatus'] as num?)?.toInt(),
  note: json['note'] as String?,
);

Map<String, dynamic> _$ExchangeRequestRequestModelToJson(
  ExchangeRequestRequestModel instance,
) => <String, dynamic>{'newStatus': instance.newStatus, 'note': instance.note};
