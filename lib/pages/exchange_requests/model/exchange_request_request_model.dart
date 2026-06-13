import 'package:json_annotation/json_annotation.dart';

part 'exchange_request_request_model.g.dart';

@JsonSerializable()
class ExchangeRequestRequestModel {
  final int? newStatus;
  final String? note;

  const ExchangeRequestRequestModel({this.newStatus, this.note});
  factory ExchangeRequestRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRequestRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExchangeRequestRequestModelToJson(this);
}
