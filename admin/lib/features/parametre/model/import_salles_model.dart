class ImportSallesModel {
  final bool success;
  final String message;
  final int count;

  ImportSallesModel({
    required this.success,
    required this.message,
    required this.count,
  });

  factory ImportSallesModel.fromJson(Map<String, dynamic> json) {
    return ImportSallesModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}