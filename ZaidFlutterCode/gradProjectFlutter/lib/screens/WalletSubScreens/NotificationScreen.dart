import 'package:blood_bank/models/AppNotification.dart';
import 'package:blood_bank/modules/defaultDrawer.dart';
import 'package:blood_bank/shared/network/NotificationService.dart';
import 'package:blood_bank/shared/network/StoreNotifications.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<AppNotification>> notificationsFuture;
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final store = NotificationStore.instance;
    void initState() {
      super.initState();
      notificationsFuture = NotificationService.fetchDummyNotifications();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      drawer: DefaultDrawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: AnimatedBuilder(
            animation: store,
            builder: (context, child) {
              final notifications = store.items;

              if (notifications.isEmpty) {
                if (isWide) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            size: 64,
                            color: mainColor,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'You have no notifications',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your notifications will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: Text('You have no notifications'));
              }

              return ListView.builder(
                padding: isWide ? const EdgeInsets.all(24) : null,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  final tile = ListTile(
                    contentPadding: isWide
                        ? const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          )
                        : null,
                    titleAlignment: isWide
                        ? ListTileTitleAlignment.center
                        : null,
                    leading: Icon(
                      Icons.notifications,
                      color: isWide ? mainColor : null,
                    ),
                    title: Text(
                      notification.title,
                      style: isWide
                          ? const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )
                          : null,
                    ),
                    subtitle: Text(
                      notification.body,
                      style: isWide
                          ? const TextStyle(fontSize: 14, height: 1.5)
                          : null,
                    ),
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
                  if (!isWide) return tile;
                  return Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.1),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: tile,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
