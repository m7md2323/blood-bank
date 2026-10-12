import 'dart:convert';

import 'package:blood_bank/models/AppNotification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:blood_bank/router/appRouter.dart';
import 'package:blood_bank/shared/network/StoreNotifications.dart';
import 'package:flutter/services.dart';

class NotificationService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await messaging.getToken();
    debugPrint('FCM token: $token');

    messaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM token refreshed: $newToken');

      // Later: send the token to your authenticated .NET API.
    });

    // App is open and receives a message.
    FirebaseMessaging.onMessage.listen((message) {
      NotificationStore.instance.addRemoteMessage(message);

      debugPrint('Received: ${message.notification?.title}');
    });

    // App was in the background and the user tapped the notification.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    // App was terminated and the user tapped the notification.
    final initialMessage = await messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleTap(initialMessage);
    }
  }

  static void _handleTap(RemoteMessage message) {
    NotificationStore.instance.addRemoteMessage(message);

    final screen = message.data['screen']?.toString();
    final requestId = message.data['requestId']?.toString();

    if (screen == 'blood_request' &&
        requestId != null &&
        requestId.isNotEmpty) {
      appRouter.push(
        '/blood-request/${Uri.encodeComponent(requestId)}',
      );
    }
  }

  // Use this same method when an inbox item is tapped.
  static void openRequest(String requestId) {
    appRouter.push(
      '/blood-request/${Uri.encodeComponent(requestId)}',
    );
  }
  static Future<List<AppNotification>> fetchDummyNotifications() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/notifications_dummy.json',
  );

  final List<dynamic> jsonData = jsonDecode(jsonString);

  return jsonData.map((item) {
    return AppNotification.fromJson(
      item as Map<String, dynamic>,
    );
  }).toList();
}
}
