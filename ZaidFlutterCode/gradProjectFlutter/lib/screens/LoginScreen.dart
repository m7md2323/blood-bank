import 'package:flutter/material.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/network/AuthService.dart'; // Adjust path as needed

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nationalIDController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPassword = true;
  final AuthService myAuthService = AuthService();

  @override
  void dispose() {
    // Always clean up controllers when leaving the screen
    nationalIDController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Column(
          children: [
            MainLogo(),
            Text(
              "help save lives",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Times New Roman',
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            // Changed height from fixed * 0.8 to a minimum constraint so it adapts gracefully without layout overflows
            child: DefaultCard(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    // --- National ID Field ---
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultFormField(
                            textControl: nationalIDController,
                            type: TextInputType.number,
                            label: 'Enter your national ID',
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'field cannot be empty';
                              }
                              return null;
                            },
                            prefix: Icons.numbers,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.08),

                    // --- Password Field ---
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DefaultFormField(
                            isPassword:
                                isPassword, // FIXED: Uses state variable instead of static true
                            textControl: passwordController,
                            type: TextInputType.visiblePassword,
                            label: 'Enter your password',
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'field cannot be empty';
                              }
                              return null;
                            },
                            prefix: Icons.password,
                            suffix: isPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            suffixPressed: () {
                              setState(() {
                                isPassword = !isPassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),

                    // --- Login Button with Snackbar Trigger ---
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: DefaultButton(
                        buttonText: "Login",
                        function: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              // TEMPORARY TEST: Skip API and test the snackbar layout engine
                              throw "Authentication failed: This is a test error from the backend!";
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
                    ),

                    // --- FIXED FOOTER: Safely moved back inside the central layout column list ---
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    TextButton(
                      onPressed: () {},
                      child: const Text("forgot password?"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("no account?"),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "sign up",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text("hospital/ blood bank staff?"),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
