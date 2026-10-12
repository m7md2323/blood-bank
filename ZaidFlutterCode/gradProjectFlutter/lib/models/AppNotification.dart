class AppNotification {
  final String title;
  final String body;
  final String? requestId;
  final DateTime receivedAt;
  bool isRead;

  AppNotification({
    required this.title,
    required this.body,
    this.requestId,
    DateTime? receivedAt,
    this.isRead = false,
  }) : receivedAt = receivedAt ?? DateTime.now();

 factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json['title'] as String,
      body: json['body'] as String,
      requestId: json['requestId']?.toString(),
      receivedAt: DateTime.parse(json['receivedAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
  }