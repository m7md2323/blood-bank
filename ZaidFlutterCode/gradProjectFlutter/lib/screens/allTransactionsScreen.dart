import 'package:blood_bank/shared/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/shared/network/AuthService.dart';
import 'package:blood_bank/models/visits.dart';
import 'bloodwalletscreen.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';
import 'package:intl/intl.dart';

class Alltransactionsscreen extends StatelessWidget {
  Alltransactionsscreen({super.key});
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainColor),
      body: FutureBuilder<List<Visit>>(
        future: authService.fetchVisits(), // Fetch visits from the API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final visit = snapshot.data![index];
                return ListTile(
                  leading: Icon(
                    Icons.bloodtype,
                    color: mainColor,
                  ), //EDIT NEEDED: fetch icon from database based on transaction type
                  title: Text(
                    "visit Type: ${visit.visitType}",
                    style: TextStyle(
                      fontSize: context.resWidth(0.04),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Date: ${DateFormat('dd/MM/yyyy').format(visit.visitDate)}",
                    style: TextStyle(fontSize: context.resWidth(0.03)),
                  ),
                  trailing: Text(
                    "-${1} Units",
                    style: TextStyle(
                      fontSize: context.resWidth(0.04),
                      color: Colors
                          .red, //EDIT NEEDED: isDonation feature needs to be implemented to determine if the transaction is a donation or not, and change the color accordingly
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
