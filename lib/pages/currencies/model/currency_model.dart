import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_model.g.dart';

@JsonSerializable()
class CurrencyModel {
  final String? id;
  final String? code;
  final String? name;
  final String? symbol;
  final bool? isActive;
  final String? createdOn;

  const CurrencyModel({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.isActive,
    this.createdOn,
  });
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return _$CurrencyModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CurrencyModelToJson(this);
  }
}
