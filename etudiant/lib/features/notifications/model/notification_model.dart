class NotificationModel {
  final int id;
  final String title;
  final String content;
  final String from;
  final String authSender;
  final String? targetStudentId;
  final String? targetGroup;
  final String? targetSituation;
  final bool isGlobal;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.from,
    required this.authSender,
    this.targetStudentId,
    this.targetGroup,
    this.targetSituation,
    required this.isGlobal,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      from: json['from'] ?? '',
      authSender: json['auth_sender'] ?? '',
      targetStudentId: json['targetStudentId']?.toString(),
      targetGroup: json['targetGroup']
          ?.toString(), // ✅ int or String → always String
      targetSituation: json['targetSituation']?.toString(),
      isGlobal: json['isGlobal'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
