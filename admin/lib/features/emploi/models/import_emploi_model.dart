class ImportEmploiModel {
  final bool success;
  final String message;
  final int count;

  ImportEmploiModel({
    required this.success,
    required this.message,
    required this.count,
  });

  factory ImportEmploiModel.fromJson(Map<String, dynamic> json) {
    return ImportEmploiModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}