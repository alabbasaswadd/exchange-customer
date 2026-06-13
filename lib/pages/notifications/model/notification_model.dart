class NotificationModel {
  final String? id;
  final String? title;
  final String? body;
  final bool? isRead;
  final String? type;
  final String? createdAt;

  const NotificationModel({
    this.id,
    this.title,
    this.body,
    this.isRead,
    this.type,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String?,
        title: json['title'] as String?,
        body: json['body'] as String?,
        isRead: json['isRead'] as bool?,
        type: json['type'] as String?,
        createdAt: json['createdAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'isRead': isRead,
        'type': type,
        'createdAt': createdAt,
      };

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        title: title,
        body: body,
        isRead: isRead ?? this.isRead,
        type: type,
        createdAt: createdAt,
      );
}
