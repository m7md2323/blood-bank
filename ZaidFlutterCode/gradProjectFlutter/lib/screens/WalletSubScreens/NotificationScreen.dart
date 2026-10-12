import 'package:blood_bank/models/AppNotification.dart';
import 'package:blood_bank/shared/network/NotificationService.dart';
import 'package:blood_bank/shared/network/StoreNotifications.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/shared/network/AuthService.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';
import 'package:flutter_map/flutter_map.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<AppNotification>> notificationsFuture;
  @override
  Widget build(BuildContext context) {
    final store = NotificationStore.instance;
    void initState() {
      super.initState();
      notificationsFuture = NotificationService.fetchDummyNotifications();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, child) {
          final notifications = store.items;

          if (notifications.isEmpty) {
            return const Center(child: Text('You have no notifications'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(notification.title),
                subtitle: Text(notification.body),
                trailing: notification.isRead
                    ? null
                    : const Icon(Icons.circle, size: 10, color: Colors.red),
                onTap: () {
                  store.markRead(notification);

                  final requestId = notification.requestId;

                  if (requestId != null && requestId.isNotEmpty) {
                    NotificationService.openRequest(requestId);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
