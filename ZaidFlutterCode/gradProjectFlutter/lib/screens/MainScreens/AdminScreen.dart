import 'package:blood_bank/models/users.dart';
import 'package:blood_bank/modules/donorProximityMap.dart';
import 'package:blood_bank/shared/network/AuthService.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool isBottomSheetShown = false;
  Key scaffoldKey = GlobalKey<ScaffoldState>();
  String? bloodType;
  bool? isUrgent;
  bool isRequestFullfilled = false;
  TextEditingController unitCountController = TextEditingController();
  late final Stream<List<Users>> donorsLocation;
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    donorsLocation = fetchUsersPeriodically();
  }

  Stream<List<Users>> fetchUsersPeriodically() async* {
    while (true) {
      try {
        yield await dummyFetchUsers();
      } catch (e) {
        debugPrint('Failed to fetch donor locations: $e');
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  void dispose() {
    unitCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: Icon(Icons.bloodtype),
        actions: [
          Text(
            "central north blood center",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ), //fetch hospital name
          IconButton(
            onPressed: () => debugPrint("Logout function"),
            icon: Text("Log-out"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (!isBottomSheetShown) {
            if (isBottomSheetShown) return;

            setState(() {
              isBottomSheetShown = true;
            });
            showModalBottomSheet(
              context: context,
              builder: (sheetContext) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Blood type',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: bloodType,
                        items: const [
                          DropdownMenuItem(value: 'O+', child: Text('O+')),
                          DropdownMenuItem(value: 'O-', child: Text('O-')),
                          DropdownMenuItem(value: 'A+', child: Text('A+')),
                          DropdownMenuItem(value: 'A-', child: Text('A-')),
                          DropdownMenuItem(value: 'B+', child: Text('B+')),
                          DropdownMenuItem(value: 'B-', child: Text('B-')),
                          DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                          DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            bloodType = value;
                          });
                        },
                      ),
                      SizedBox(height: context.resHeight(0.03)),
                      DropdownButtonFormField<bool>(
                        //EDIT NEEDED: count?s
                        decoration: const InputDecoration(
                          labelText: 'Urgency',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: false,
                        items: [
                          DropdownMenuItem(value: true, child: Text('Urgent')),
                          DropdownMenuItem(
                            value: false,
                            child: Text('Not urgent'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            isUrgent = value;
                          });
                        },
                      ),
                      SizedBox(height: context.resHeight(0.03)),
                      DefaultFormField(
                        textControl: unitCountController,
                        label: "Units required",
                        prefix: Icons.numbers,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'field cannot be empty';
                          }
                          return null;
                        },
                        type: TextInputType.numberWithOptions(),
                      ),
                    ],
                  ),
                );
              },
            ).whenComplete(() {
              if (mounted) {
                setState(() {
                  isBottomSheetShown = false;
                });
              }
            });
          }
        },
        splashColor: Colors.white,
        label: Text(
          "send a request to users",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mainColor,
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,

      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: context.resHeight(0.2),
                width: context.resWidth(1),
                padding: EdgeInsets.symmetric(
                  vertical: context.resHeight(0.03),
                  horizontal: context.resWidth(0.1),
                ),
                child: DefaultCard(
                  color: mainColor,
                  child: Center(
                    child: Text(
                      "total requests for 'date': '#'",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: context.resWidth(0.05),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: context.resHeight(0.2),
                width: context.resWidth(1),
                padding: EdgeInsets.symmetric(
                  vertical: context.resHeight(0.03),
                  horizontal: context.resWidth(0.1),
                ),
                child: DefaultCard(
                  color: mainColor,
                  child: Center(
                    child: Text(
                      "requests answered for 'date': '#'",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: context.resWidth(0.045),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: context.resHeight(0.2),
                width: context.resWidth(1),
                padding: EdgeInsets.symmetric(
                  vertical: context.resHeight(0.03),
                  horizontal: context.resWidth(0.1),
                ),
                child: DefaultCard(
                  color: mainColor,
                  child: Center(
                    child: Text(
                      "cases fulfilled for 'date': '#'",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: context.resWidth(0.05),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.resWidth(0.02),
                0,
                0,
                context.resWidth(0.02),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Current requests out", //EDIT NEEDED: add a fetching function and an 'if' to validate if null
                    style: TextStyle(
                      fontSize: context.resWidth(0.05),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(3, (index) {
                return ExpansionTile(
                  leading: const Text("O+"), // Blood type

                  title: Text(
                    "Request ${index + 1}: Request Center",
                    style: TextStyle(
                      fontSize: context.resWidth(0.04),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    "Date of request ${index + 1}",
                    style: TextStyle(fontSize: context.resWidth(0.03)),
                  ),

                  trailing: Text(
                    isRequestFullfilled ? "Fulfilled" : "Not fulfilled",
                    style: TextStyle(
                      fontSize: context.resWidth(0.03),
                      color: isRequestFullfilled ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Information revealed when expanded
                  children: [
                    ListTile(
                      leading: const Icon(Icons.bloodtype),
                      title: const Text("Blood type"),
                      subtitle: const Text("O+"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.water_drop),
                      title: const Text("Units needed"),
                      subtitle: const Text("6 units"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.local_hospital),
                      title: const Text("Request center"),
                      subtitle: const Text("Central North Blood Center"),
                    ),
                  ],
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, context.resHeight(0.02), 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Current donors locations out", //EDIT NEEDED: add a fetching function and an 'if' to validate if null
                    style: TextStyle(
                      fontSize: context.resWidth(0.05),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                context.resWidth(0.05),
                context.resHeight(0.05),
                context.resWidth(0.05),
                context.resHeight(0.05),
              ),
              child: StreamBuilder(
                stream: donorsLocation,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Text("error: $asyncSnapshot.error");
                  }
                  if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting &&
                      !asyncSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final donors = asyncSnapshot.data!;
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      0,
                      context.resWidth(0.02),
                      0,
                    ),
                    child: DonorProximityMap(
                      donors: donors,
                      mapController: mapController,
                    ),
                  );
                },
              ),
            ),
            //EDIT NEEDED: add a "add credit to donor" widget
          ],
        ),
      ),
    );
  }
}
