import 'package:flutter/material.dart';
import 'package:blood_bank/shared/network/AuthService.dart'; 
import 'package:blood_bank/shared/styles/components.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        itemCount: 10, // Replace with your actual notification count
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications),
            title: Text('Notification ${index + 1}'),
            subtitle: const Text('This is a sample notification.'),
            onTap: () {
              // Handle notification tap
            },
          );
        },
      ),
    );
  }
}
