import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/screens/homePage.dart';
import 'package:blood_bank/screens/LoginScreen.dart';

final GoRouter appRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      )
    ]);