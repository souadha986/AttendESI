class ImportMatieresModel {
  final bool success;
  final String message;
  final int count;

  ImportMatieresModel({
    required this.success,
    required this.message,
    required this.count,
  });

  factory ImportMatieresModel.fromJson(Map<String, dynamic> json) {
    return ImportMatieresModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}