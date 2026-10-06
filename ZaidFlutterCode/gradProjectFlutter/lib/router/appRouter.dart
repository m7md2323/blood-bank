import 'package:blood_bank/screens/MainScreens/MapScreen.dart';
import 'package:blood_bank/screens/WalletSubScreens/AllTransactionsScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:blood_bank/screens/MainScreens/LoginScreen.dart';
import 'package:blood_bank/screens/MainScreens/BloodWalletScreen.dart';
import 'package:blood_bank/screens/WalletSubScreens/NotificationScreen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/map-screen',
  routes: [
    GoRoute(path: '/', builder: (context, state) => LoginScreen()),
    GoRoute(
      path: '/blood-wallet',
      builder: (context, state) => Bloodwalletscreen(),
    ),
    GoRoute(
      path: '/all-transactions',
      builder: (context, state) => Alltransactionsscreen(),
    ),
    GoRoute(
      path: '/notification-screen',
      builder: (context, state) => NotificationScreen(),
    ),
    GoRoute(path: '/map-screen', builder: (context, state) => MapScreen()),
    GoRoute(
      path: '/test',
      builder: (context, state) {
        print("TEST ROUTE BUILDER CALLED");

        return const Scaffold(body: Center(child: Text("HELLO")));
      },
    ),
  ],
);
