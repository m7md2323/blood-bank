import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/network/AuthService.dart'; // Adjust path as needed
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //variables / constants here
  final nationalIDController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPassword = true;
  final AuthService myAuthService = AuthService();

  Future<void> signUp() async {
    final response = await http.post(
      Uri.parse('${AuthService.baseUrl}/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nationalID': nationalIDController.text,
        'password': passwordController.text,
        'passwordConfirm': confirmPasswordController.text,
        'email': emailController.text,
        'phone': phoneNumberController.text,
      }),
    );
    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      debugPrint("asds");
    }
  }

  //@override dispose
  @override
  void dispose() {
    nationalIDController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text("Sign UP"),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: DefaultCard(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MainLogo(),
                  Text("Sign Up"),
                  SizedBox(height: 30),
                  DefaultFormField(
                    textControl: nationalIDController,
                    label: "enter your national ID",
                    prefix: Icons.numbers,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field cannot be empty';
                      }
                      return null;
                    },
                    type: TextInputType.number,
                  ),
                  //////
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  DefaultFormField(
                    isPassword: isPassword,
                    textControl: passwordController,
                    label: "enter your password",
                    prefix: Icons.password_sharp,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field cannot be empty';
                      }
                      return null;
                    },
                    type: TextInputType.visiblePassword,
                    suffix: isPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    suffixPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                  ),
                  /////////////////
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  ////////////////
                  DefaultFormField(
                    isPassword: isPassword,
                    textControl: confirmPasswordController,
                    label: "enter your password again",
                    prefix: Icons.password_sharp,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field cannot be empty';
                      }
                      return null;
                    },
                    type: TextInputType.visiblePassword,
                    suffix: isPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    suffixPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                  ),
                  //////
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  DefaultFormField(
                    textControl: emailController,
                    label: "enter your Email",
                    prefix: Icons.email,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field cannot be empty';
                      }
                      return null;
                    },
                    type: TextInputType.emailAddress,
                  ),
                  ////////
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  DefaultFormField(
                    textControl: phoneNumberController,
                    label: "enter your phone number",
                    prefix: Icons.phone,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field cannot be empty';
                      }
                      return null;
                    },
                    type: TextInputType.phone,
                  ),
                  ////////////
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  DefaultButton(
                    buttonText: "Create account",
                    function: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          await signUp();
                        } catch (error) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red.shade700,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 4),
                                content: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        error.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
