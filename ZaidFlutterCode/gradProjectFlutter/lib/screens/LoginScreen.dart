import 'package:flutter/material.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart.';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainLogo(),
        centerTitle: true,
      ),
      body: Center()

    );
  }
}
