class ImportProfModel {
  final bool success;
  final String message;

  ImportProfModel({
    required this.success,
    required this.message,
  });

  factory ImportProfModel.fromJson(Map<String, dynamic> json) {
    return ImportProfModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}