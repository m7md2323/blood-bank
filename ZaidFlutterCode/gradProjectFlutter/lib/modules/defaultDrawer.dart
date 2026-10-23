import 'package:blood_bank/shared/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("accountName"),
            accountEmail: Text('accountEmail'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person, color: Colors.blue),
            ),
            arrowColor: mainColor,
            decoration: BoxDecoration(color: mainColor),
            currentAccountPictureSize: Size(22, 30),
          ),

          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              context.go('/home-screen');
              // Navigate to profile screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigate to settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.wallet),
            title: const Text('Blood wallet'),
            onTap: () {
              context.go('/wallet-screen');
              // Navigate to profile screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Donation centers map'),
            onTap: () {
              context.go('/map-screen');
              // Navigate to profile screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.notification_add),
            title: const Text('notifications'),
            onTap: () {
              context.go('/notification-screen');
              // Navigate to profile screen
            },
          ),
          const Spacer(),

          const Divider(), // A subtle separation line

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Handle your logout logic here
            },
          ),
        ],
      ),
    );
  }
}
