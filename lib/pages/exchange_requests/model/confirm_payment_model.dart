import 'package:json_annotation/json_annotation.dart';

part 'confirm_payment_model.g.dart';

@JsonSerializable()
class ConfirmPaymentModel {
  final String? transactionNumber;

  const ConfirmPaymentModel({this.transactionNumber});
  factory ConfirmPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$ConfirmPaymentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ConfirmPaymentModelToJson(this);
}
