class NotificationModel {
  final int id;
  final String authId;
  final String senderName;
  final String message;
  final String titre;
  final String role;
  final String date;

  NotificationModel({
    required this.id,
    required this.authId,
    required this.senderName,
    required this.message,
    required this.titre,
    required this.role,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      authId: json['authId'] ?? '',
      senderName: json['senderName'] ?? '',
      message: json['message'] ?? '',
      titre: json['titre'] ?? '',
      role: json['role'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
class NotificationDetailModel {
  int? id;
  String? sujet;
  String? description;
  String? senderName;
  String? authId;
  String? role;
  List<String>? fileUrls;
  String? createdAt;
  String? statut;
  String? user;

  NotificationDetailModel({
    this.id,
    this.sujet,
    this.description,
    this.senderName,
    this.authId,
    this.role,
    this.fileUrls,
    this.createdAt,
    this.statut,
    this.user,
  });

  factory NotificationDetailModel.fromJson(Map<String, dynamic> json) {
    return NotificationDetailModel(
      id: json['id'],
      sujet: json['sujet'],
      description: json['description'],
      senderName: json['senderName'],
      authId: json['authId'],
      role: json['role'],
      fileUrls: json['fileUrls'] != null
          ? List<String>.from(json['fileUrls'])
          : [],
      createdAt: json['createdAt'],
      statut: json['statut'],
      user: json['user'],
    );
  }
}
class SendNotificationResponseModel {
  int? id;
  String? title;
  String? content;
  String? from;
  String? authSender;
  List<String>? targetStudentId;
  List<dynamic>? targetGroup;
  String? targetSituation;
  bool? isGlobal;
  String? createdAt;

  SendNotificationResponseModel({
    this.id,
    this.title,
    this.content,
    this.from,
    this.authSender,
    this.targetStudentId,
    this.targetGroup,
    this.targetSituation,
    this.isGlobal,
    this.createdAt,
  });

  factory SendNotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return SendNotificationResponseModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      from: json['from'],
      authSender: json['auth_sender'],
      targetStudentId: json['targetStudentId'] != null
          ? List<String>.from(json['targetStudentId'])
          : [],
      targetGroup: json['targetGroup'] != null
          ? List<dynamic>.from(json['targetGroup'])
          : [],
      targetSituation: json['targetSituation'],
      isGlobal: json['isGlobal'],
      createdAt: json['createdAt'],
    );
  }
}