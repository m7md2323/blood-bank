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
  final MapController mapController = MapController();
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications Screen')),
      body: Column(),
    );
  }
}
