class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;

  Notification(
      {required this.id, required this.title, required this.message, required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
