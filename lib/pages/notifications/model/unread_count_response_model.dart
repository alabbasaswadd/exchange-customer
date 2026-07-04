class UnreadCountResponseModel {
  final bool? succeeded;
  final int? data;

  const UnreadCountResponseModel({this.succeeded, this.data});

  factory UnreadCountResponseModel.fromJson(Map<String, dynamic> json) =>
      UnreadCountResponseModel(
        succeeded: json['succeeded'] as bool?,
        data: json['data'] as int?,
      );
}
