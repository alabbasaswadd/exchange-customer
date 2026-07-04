import 'package:exchange_customer/pages/notifications/model/notification_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_list_response_model.g.dart';

@JsonSerializable()
class NotificationListResponseModel {
  final bool? succeeded;
  final NotificationDataModel? data;

  const NotificationListResponseModel({this.succeeded, this.data});

  factory NotificationListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationListResponseModelToJson(this);
}

@JsonSerializable()
class NotificationDataModel {
  final List<NotificationModel>? items;
  final int? total;
  final int? page;
  final int? pageSize;
  final int? totalPages;

  const NotificationDataModel({
    this.items,
    this.total,
    this.page,
    this.pageSize,
    this.totalPages,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataModelToJson(this);
}
