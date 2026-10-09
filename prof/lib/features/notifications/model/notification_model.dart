class NotificationModel {
  final int id;
  final String title;
  final String content;
  final String sender;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.sender,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      sender: json['sender'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }
}
