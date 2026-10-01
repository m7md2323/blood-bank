import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:blood_bank/screens/LoginScreen.dart';
import 'package:blood_bank/screens/BloodWalletScreen.dart';
import 'package:blood_bank/screens/allTransactionsScreen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/blood-wallet',
  routes: [
    GoRoute(path: '/', builder: (context, state) => Bloodwalletscreen()),
    GoRoute(
      path: '/blood-wallet',
      builder: (context, state) => Bloodwalletscreen(),
    ),
    GoRoute(
      path: '/all-transactions',
      builder: (context, state) => Alltransactionsscreen(),
    ),
  ],
);
