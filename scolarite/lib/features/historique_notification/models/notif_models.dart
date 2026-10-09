class NotifModel {
  final List<Message> messages;

  NotifModel({required this.messages});

  factory NotifModel.fromJson(List<dynamic> json) {
    return NotifModel(
      messages: json.map((e) => Message.fromJson(e)).toList(),
    );
  }
}

class Message {
  final int? id;
  final String? title;
  final String? content;
  final String? sender;
  final DateTime? date;

  Message({
    this.id,
    this.title,
    this.content,
    this.sender,
    this.date,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      sender: json['sender'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}