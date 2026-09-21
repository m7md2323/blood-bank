import 'package:flutter/material.dart';
import 'package:blood_bank/screens/LoginScreen.dart';
import 'package:blood_bank/screens/BloodWalletScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const Bloodwalletscreen());
  }
}
