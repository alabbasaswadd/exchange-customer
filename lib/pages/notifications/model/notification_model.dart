import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String? id;
  final String? title;
  final String? body;
  final bool? isRead;
  final int? notificationType;
  final String? createdOn;

  const NotificationModel({
    this.id,
    this.title,
    this.body,
    this.isRead,
    this.notificationType,
    this.createdOn,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
