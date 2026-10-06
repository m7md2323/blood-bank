import 'package:flutter/material.dart';
import 'package:blood_bank/router/appRouter.dart';

void main() {
  runApp(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    ),
  );
}
