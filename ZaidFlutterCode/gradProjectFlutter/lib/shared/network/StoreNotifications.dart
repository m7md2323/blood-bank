
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:blood_bank/models/AppNotification.dart';

class NotificationStore extends ChangeNotifier {
  NotificationStore._();

  static final NotificationStore instance = NotificationStore._();

  final List<AppNotification> _items = [];

  List<AppNotification> get items =>
      List.unmodifiable(_items);

  void addRemoteMessage(RemoteMessage message) {
    final title = message.notification?.title ??
        message.data['title']?.toString() ??
        'Blood Bank Notification';

    final body = message.notification?.body ??
        message.data['body']?.toString() ??
        '';

    final requestId = message.data['requestId']?.toString();

    // Avoid duplicate entries when the same message is handled
    // through more than one callback.
    if (message.messageId != null &&
        _items.any((item) =>
            item.requestId == requestId &&
            item.title == title &&
            item.body == body)) {
      return;
    }

    _items.insert(
      0,
      AppNotification(
        title: title,
        body: body,
        requestId: requestId,
      ),
    );

    notifyListeners();
  }

  void markRead(AppNotification item) {
    item.isRead = true;
    notifyListeners();
  }
}
