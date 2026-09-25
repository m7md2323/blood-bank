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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: DefaultCard(
                color: mainColor,
                child: Column(
                  children: [
                    DefaultSizedBox(width: 0, height: 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "wallet card",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 33,
                                  fontFamily: "Inter",
                                ),
                              ),
                              Text(
                                'Jordan Blood Bank . User ID: $placeHolder', //fetch ID from DataBase
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 3,
                          child: CircleAvatar(
                            backgroundColor: Colors
                                .white, //fetch user picture from DataBase , have a default if none added
                            radius: 17,
                          ),
                        ),
                      ],
                    ),
                    DefaultSizedBox(height: 0.02, width: 0),
                    Expanded(
                      child: DefaultCard(
                        color: Colors.white60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, //needs to be aligned to the left
                          children: [
                            //and need to fix the white space to have text to appear
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Current credit: ",
                                  style: GoogleFonts.inter(),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "$placeHolder ", //fetch credit from DataBase
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("Units", style: GoogleFonts.inter()),
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
            DefaultSizedBox(),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      children: [
                        //all 4 buttons still need interactivity coded
                        FloatingActionButton(
                          onPressed: () => debugPrint("lolol"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.card_giftcard_rounded),
                        ),
                        Text("Redeem", style: GoogleFonts.inter()),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () => debugPrint("lolol"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.arrow_circle_up_rounded),
                        ),
                        Text("Transfer", style: GoogleFonts.inter()),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () => debugPrint("lolol"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.card_membership),
                        ),
                        Text("Certificate", style: GoogleFonts.inter()),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () => debugPrint("lolol"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.share),
                        ),
                        Text("share", style: GoogleFonts.inter()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              color: Colors.grey,
              child: Text(
                "donation activities",
                style: TextStyle(fontSize: 15),
              ), // Optional: Add a child widget if needed
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
            ),

            //4 buttons
          ],
        ),
      ),
    );
  }
}
