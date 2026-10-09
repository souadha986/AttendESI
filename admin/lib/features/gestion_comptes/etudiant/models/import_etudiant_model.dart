class ImportEtudiantModel {
  final bool success;
  final String message;

  ImportEtudiantModel({
    required this.success,
    required this.message,
  });

  factory ImportEtudiantModel.fromJson(Map<String, dynamic> json) {
    return ImportEtudiantModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}