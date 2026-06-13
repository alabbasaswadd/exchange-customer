import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_request_model.g.dart';

@JsonSerializable()
class CurrencyRequestModel {
  final String code;
  final String name;
  final String symbol;
  final bool isActive;

  const CurrencyRequestModel({
    required this.name,
    required this.code,
    required this.symbol,
    this.isActive = true,
  });
  factory CurrencyRequestModel.fromjson(Map<String, dynamic> json) {
    return _$CurrencyRequestModelFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$CurrencyRequestModelToJson(this);
  }
}
