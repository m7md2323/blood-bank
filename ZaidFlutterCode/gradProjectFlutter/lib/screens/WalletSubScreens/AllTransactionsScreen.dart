import 'package:blood_bank/shared/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/shared/network/AuthService.dart';
import 'package:blood_bank/models/visits.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';
import 'package:intl/intl.dart';

class Alltransactionsscreen extends StatelessWidget {
  Alltransactionsscreen({super.key});
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    return Scaffold(
      appBar: AppBar(backgroundColor: mainColor),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWide)
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 28, 24, 16),
                  child: Text(
                    'Transaction History',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                ),
              Expanded(
                child: FutureBuilder<List<Visit>>(
                  future: authService
                      .dummyFetchVisits(), //EDIT NEEDED: Fetch visits from the API
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No transactions found.'),
                      );
                    } else {
                      return ListView.builder(
                        padding: isWide
                            ? const EdgeInsets.fromLTRB(24, 8, 24, 24)
                            : null,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final visit = snapshot.data![index];
                          final tile = ListTile(
                            contentPadding: isWide
                                ? const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 8,
                                  )
                                : null,
                            titleAlignment: isWide
                                ? ListTileTitleAlignment.center
                                : null,
                            leading: Icon(
                              Icons.bloodtype,
                              color: mainColor,
                            ), //EDIT NEEDED: fetch icon from database based on transaction type
                            title: Text(
                              isWide
                                  ? visit.visitType
                                  : "visit Type: ${visit.visitType}",
                              style: TextStyle(
                                fontSize: isWide ? 16 : context.resWidth(0.04),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Date: ${DateFormat('dd/MM/yyyy').format(visit.visitDate)}",
                              style: TextStyle(
                                fontSize: isWide ? 14 : context.resWidth(0.03),
                                height: isWide ? 1.6 : null,
                              ),
                            ),
                            trailing: Text(
                              "-${1} Units",
                              style: TextStyle(
                                fontSize: isWide ? 16 : context.resWidth(0.04),
                                color: Colors
                                    .red, //EDIT NEEDED: isDonation feature needs to be implemented to determine if the transaction is a donation or not, and change the color accordingly
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                          if (!isWide) return tile;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: tile,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
