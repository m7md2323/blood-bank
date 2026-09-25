import 'package:blood_bank/screens/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/network/AuthService.dart'; // Adjust path as needed
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class Bloodwalletscreen extends StatelessWidget {
  const Bloodwalletscreen({super.key});
  final String placeHolder = 'your_token_here';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getResponsiveHeight(context, 0.4),
                width: getResponsiveWidth(context, 1),
                child: DefaultCard(
                  color: mainColor,
                  child: Column(
                    children: [
                      DefaultSizedBox(width: 0, height: 0.08),
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
                                  'Jordan Blood Bank . User ID: $placeHolder', //EDIT NEEDED: fetch ID from database
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
                                  .white, //EDIT NEEDED: fetch user picture from database, have a default if none added
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Current credit: ",
                                    style: GoogleFonts.inter(),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "$placeHolder ", //EDIT NEEDED: fetch credit from database
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
                      DefaultSizedBox(
                        height: getResponsiveHeight(context, 0.0001),
                        width: 0,
                      ),
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
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveWidth(context, 0.05),
                  vertical: getResponsiveHeight(context, 0.02),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: getResponsiveHeight(context, 0.03),
                      child: Text(
                        "donation activities",
                        style: TextStyle(
                          fontSize: getResponsiveWidth(context, 0.047),
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Optional: Add a child widget if needed
                    ),
                    SizedBox(
                      height: getResponsiveHeight(context, 0.02),
                      child: Text(
                        "Last ... months", // EDIT NEEDED: fetch months from database
                        style: TextStyle(
                          fontSize: getResponsiveWidth(context, 0.03),
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Optional: Add a child widget if needed
                    ),
                  ],
                ),
              ),

              BarChart(
                //EDIT NEEDED: fetch data from database to display in chart
                BarChartData(
                  // read about it in the BarChartData section
                ),
                duration: Duration(milliseconds: 150), // Optional
                curve: Curves.linear, // Optional
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.3,
              ),

              //4 buttons
            ],
          ),
        ),
      ),
    );
  }
}
