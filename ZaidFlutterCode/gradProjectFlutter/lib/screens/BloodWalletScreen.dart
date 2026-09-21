import 'package:blood_bank/screens/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/network/AuthService.dart'; // Adjust path as needed
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class Bloodwalletscreen extends StatelessWidget {
  const Bloodwalletscreen({super.key});
  final String placeHolder = 'your_token_here';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: DefaultCard(
              color: mainColor,
              child: Column(
                children: [
                  DefaultSizedBox(width: 0, height: 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "wallet card",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: "Inter",
                                ),
                              ),
                              Text(
                                'Jordan Blood Bank . User ID: $placeHolder', //fetch ID from DataBase
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: Colors
                                .white, //fetch user picture from DataBase , have a default if none added
                            radius: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  DefaultSizedBox(height: 0.02, width: 0),
                  Expanded(
                    child: DefaultCard(
                      color: Colors.white60,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Current credit: "),
                              Row(
                                children: [
                                  Text(
                                    "$placeHolder ", //fetch credit from DataBase
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Units"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  DefaultSizedBox(height: 0.1),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
        ],
      ),
    );
  }
}
