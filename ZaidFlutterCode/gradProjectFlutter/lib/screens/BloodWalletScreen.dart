import 'package:blood_bank/screens/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/network/AuthService.dart'; // Adjust path as needed
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:blood_bank/models/visits.dart';
import 'package:blood_bank/screens/allTransactionsScreen.dart';
import "package:blood_bank/shared/styles/responsive_methods.dart";

class Bloodwalletscreen extends StatefulWidget {
  @override
  State<Bloodwalletscreen> createState() => _BloodwalletscreenState();
}

class _BloodwalletscreenState extends State<Bloodwalletscreen> {
  Future<void> _bookDonation() async {
    // Use the donation center defined in database/seed.sql until a center API exists.
    const donationCenters = ['North Region Donation Center'];
    final center = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Choose a donation center'),
        children: [
          for (final center in donationCenters)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(center),
              child: Text(center),
            ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (!mounted || center == null) return;

    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
      helpText: 'Choose a donation date',
    );
    if (!mounted || date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Choose a donation time',
    );
    if (!mounted || time == null) return;

    final appointment = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    if (!appointment.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a future appointment time.')),
      );
      return;
    }

    final formattedDate = MaterialLocalizations.of(context)
        .formatMediumDate(date);
    final formattedTime = time.format(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Review donation appointment'),
        content: Text(
          '$center\n$formattedDate at $formattedTime\n\n'
          'This selection is saved for this session only. '
          'It is not confirmed with the donation center.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Save selection'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    if (!appointment.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a future appointment time.')),
      );
      return;
    }

    setState(() {
      visits.add(
        Visit(
          id: 'local-${DateTime.now().microsecondsSinceEpoch}',
          visitDate: appointment,
          visitType: 'Blood Donation',
          visitLocation: center,
          visitStatus: 'Pending',
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Appointment selection saved: $center, $formattedDate at $formattedTime',
        ),
      ),
    );
  }

  bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 600; // Adjust the threshold as needed
  }

  AuthService authService = AuthService();

  double? credit; //completed: fetch credit from database
  String? userId; //EDIT NEEDED: fetch user ID from database
  List<Visit> visits = []; //completed: fetch visits from database
  List<String> lastSixMonths =
      []; //completed: fetch last 6 months from database

  // const Bloodwalletscreen({super.key});
  final String placeHolder = 'your_token_here';
  final String userIdPlaceholder =
      'your_user_id_here'; //EDIT NEEDED: fetch user ID from database
  //Placeholder for donation status
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: context.resHeight(0.4),
                width: context.resWidth(1),
                child: DefaultCard(
                  color: mainColor,
                  child: Column(
                    children: [
                      SizedBox(width: 0, height: context.resHeight(0.04)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
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
                      SizedBox(height: context.resWidth(0.047), width: 0),
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
                                    "Current credit:",
                                    style: GoogleFonts.inter(),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        credit == null
                                            ? "Loading..."
                                            : credit!
                                                  .toString(), //EDIT Completed: fetch credit from database
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
                      SizedBox(height: context.resHeight(0.0001), width: 0),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: context.resWidth(0.047),
                height: context.resHeight(0.047),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        children: [
                          //all 4 buttons still need interactivity coded
                          FloatingActionButton(
                            heroTag: 'Redeem',
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
                            heroTag: 'Transfer',
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
                            heroTag: 'Certificate',
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
                            heroTag: 'share',
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
                  horizontal: context.resWidth(0.05),
                  vertical: context.resHeight(0.02),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: context.resHeight(0.03),
                      child: Text(
                        "donation activities",
                        style: TextStyle(
                          fontSize: context.resWidth(0.047),
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Optional: Add a child widget if needed
                    ),
                    SizedBox(
                      height: context.resHeight(0.02),
                      child: Text(
                        "Last 6 months", // EDIT NEEDED: fetch months from database
                        style: TextStyle(
                          fontSize: context.resWidth(0.03),
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Optional: Add a child widget if needed
                    ),
                  ],
                ),
              ),

              AspectRatio(
                aspectRatio: 2,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: BarChart(
                    //EDIT NEEDED: fetch data from database to display in chart
                    BarChartData(
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              List<String> lastSixMonths = authService
                                  .fetchLastSixMonths();

                              final index = value.toInt();

                              if (index < 0 || index >= lastSixMonths.length) {
                                return const SizedBox();
                              }

                              return SideTitleWidget(
                                meta: meta,
                                space: 8,
                                child: Text(
                                  lastSixMonths[index], //EDIT NEEDED: fetch months from databaseS
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      maxY: 8,
                      alignment: BarChartAlignment.start,
                      groupsSpace: 40,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      barGroups: List.generate(6, (index) {
                        return BarChartGroupData(
                          x: index,

                          barRods: [
                            BarChartRodData(
                              //return these codes once the database is connected
                              toY:
                                  true //visits[index].visitType == 'Donation'
                                  ? 6
                                  : 1,
                              color:
                                  true // visits[index].visitType == 'Donation'
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.3),
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }),
                    ),
                    duration: Duration(milliseconds: 150), // Optional
                    curve: Curves.linear, // Optional
                  ),
                ),
              ),
              /////////////
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontSize: context.resWidth(0.047),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push('/all-transactions');
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontSize: context.resWidth(0.03),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                //EDIT NEEDED :fetch # of transactions from database and display them in a list
                children: List.generate(3, (index) {
                  return ListTile(
                    leading: Icon(
                      Icons.bloodtype,
                      color: mainColor,
                    ), //EDIT NEEDED: fetch icon from database based on transaction type
                    title: Text(
                      "Transaction ${index + 1}",
                      style: TextStyle(
                        fontSize: context.resWidth(0.04),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Date of transaction ${index + 1}",
                      style: TextStyle(fontSize: context.resWidth(0.03)),
                    ),
                    trailing: Text(
                      "-${index + 1} Units",
                      style: TextStyle(
                        fontSize: context.resWidth(0.04),
                        color: Colors
                            .red, //EDIT NEEDED: isDonation feature needs to be implemented to determine if the transaction is a donation or not, and change the color accordingly
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
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
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: mainColor,
        onPressed: _bookDonation,
        label: Text(
          "Book new donation",
          style: TextStyle(
            fontSize: context.resWidth(0.04),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
