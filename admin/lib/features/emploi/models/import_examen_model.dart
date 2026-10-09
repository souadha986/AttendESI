class ImportExamenModel {
  final bool success;
  final String message;
  final int count;

  ImportExamenModel({
    required this.success,
    required this.message,
    required this.count,
  });

  factory ImportExamenModel.fromJson(Map<String, dynamic> json) {
    return ImportExamenModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}