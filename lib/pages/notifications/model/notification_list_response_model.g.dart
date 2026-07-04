// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationListResponseModel _$NotificationListResponseModelFromJson(
  Map<String, dynamic> json,
) => NotificationListResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: json['data'] == null
      ? null
      : NotificationDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationListResponseModelToJson(
  NotificationListResponseModel instance,
) => <String, dynamic>{'succeeded': instance.succeeded, 'data': instance.data};

NotificationDataModel _$NotificationDataModelFromJson(
  Map<String, dynamic> json,
) => NotificationDataModel(
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationDataModelToJson(
  NotificationDataModel instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalPages': instance.totalPages,
};
