import 'dart:async';

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
  StreamSubscription<List<Users>>? _donorsSubscription;
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    donorsLocation = fetchUsersPeriodically().asBroadcastStream(
      onListen: (subscription) {
        _donorsSubscription = subscription;
      },
    );
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
    _donorsSubscription?.cancel();
    unitCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        final contentWidth = constraints.maxWidth.clamp(0.0, 1120.0) - 48;
        final statWidth = constraints.maxWidth >= 900
            ? (contentWidth - 32) / 3
            : contentWidth;
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: mainColor,
            leading: Icon(Icons.bloodtype),
            title: isWide
                ? const Text(
                    'central north blood center',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            actions: [
              if (!isWide)
                Text(
                  "central north blood center",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ), //fetch hospital name
              IconButton(
                constraints: isWide
                    ? const BoxConstraints(minWidth: 88, minHeight: 48)
                    : null,
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
                  isScrollControlled: isWide,
                  constraints: isWide
                      ? const BoxConstraints(maxWidth: 560)
                      : null,
                  builder: (sheetContext) {
                    final form = Padding(
                      padding: EdgeInsets.all(isWide ? 24 : 16),
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
                              DropdownMenuItem(
                                value: 'AB+',
                                child: Text('AB+'),
                              ),
                              DropdownMenuItem(
                                value: 'AB-',
                                child: Text('AB-'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                bloodType = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: isWide ? 20 : context.resHeight(0.03),
                          ),
                          DropdownButtonFormField<bool>(
                            //EDIT NEEDED: count?s
                            decoration: const InputDecoration(
                              labelText: 'Urgency',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: false,
                            items: [
                              DropdownMenuItem(
                                value: true,
                                child: Text('Urgent'),
                              ),
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
                          SizedBox(
                            height: isWide ? 20 : context.resHeight(0.03),
                          ),
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
                    if (!isWide) return form;
                    return SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
                        ),
                        child: SingleChildScrollView(child: form),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: isWide ? 14 : null,
              ),
            ),
            backgroundColor: mainColor,
            icon: Icon(Icons.add),
          ),
          floatingActionButtonLocation: isWide
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.miniEndTop,

          body: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide ? 1120 : double.infinity,
                ),
                child: Padding(
                  padding: isWide
                      ? const EdgeInsets.fromLTRB(24, 24, 24, 96)
                      : EdgeInsets.zero,
                  child: Column(
                    children: [
                      Wrap(
                        spacing: isWide ? 16 : 0,
                        runSpacing: isWide ? 16 : 0,
                        children: [
                          SizedBox(
                            width: isWide ? statWidth : context.resWidth(1),
                            child: Center(
                              child: Container(
                                height: isWide ? 120 : context.resHeight(0.2),
                                width: context.resWidth(1),
                                padding: EdgeInsets.symmetric(
                                  vertical: isWide
                                      ? 0
                                      : context.resHeight(0.03),
                                  horizontal: isWide
                                      ? 0
                                      : context.resWidth(0.1),
                                ),
                                child: DefaultCard(
                                  color: mainColor,
                                  child: Center(
                                    child: Text(
                                      "total requests for 'date': '#'",
                                      textAlign: isWide
                                          ? TextAlign.center
                                          : null,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200,
                                        fontSize: isWide
                                            ? 20
                                            : context.resWidth(0.05),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: isWide ? statWidth : context.resWidth(1),
                            child: Center(
                              child: Container(
                                height: isWide ? 120 : context.resHeight(0.2),
                                width: context.resWidth(1),
                                padding: EdgeInsets.symmetric(
                                  vertical: isWide
                                      ? 0
                                      : context.resHeight(0.03),
                                  horizontal: isWide
                                      ? 0
                                      : context.resWidth(0.1),
                                ),
                                child: DefaultCard(
                                  color: mainColor,
                                  child: Center(
                                    child: Text(
                                      "requests answered for 'date': '#'",
                                      textAlign: isWide
                                          ? TextAlign.center
                                          : null,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200,
                                        fontSize: isWide
                                            ? 20
                                            : context.resWidth(0.045),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: isWide ? statWidth : context.resWidth(1),
                            child: Center(
                              child: Container(
                                height: isWide ? 120 : context.resHeight(0.2),
                                width: context.resWidth(1),
                                padding: EdgeInsets.symmetric(
                                  vertical: isWide
                                      ? 0
                                      : context.resHeight(0.03),
                                  horizontal: isWide
                                      ? 0
                                      : context.resWidth(0.1),
                                ),
                                child: DefaultCard(
                                  color: mainColor,
                                  child: Center(
                                    child: Text(
                                      "cases fulfilled for 'date': '#'",
                                      textAlign: isWide
                                          ? TextAlign.center
                                          : null,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200,
                                        fontSize: isWide
                                            ? 20
                                            : context.resWidth(0.05),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isWide ? 0 : context.resWidth(0.02),
                          isWide ? 32 : 0,
                          0,
                          isWide ? 16 : context.resWidth(0.02),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Current requests out", //EDIT NEEDED: add a fetching function and an 'if' to validate if null
                              style: TextStyle(
                                fontSize: isWide ? 20 : context.resWidth(0.05),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: List.generate(3, (index) {
                          return ExpansionTile(
                            tilePadding: isWide
                                ? const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  )
                                : null,
                            leading: const Text("O+"), // Blood type

                            title: Text(
                              "Request ${index + 1}: Request Center",
                              style: TextStyle(
                                fontSize: isWide ? 16 : context.resWidth(0.04),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              "Date of request ${index + 1}",
                              style: TextStyle(
                                fontSize: isWide ? 14 : context.resWidth(0.03),
                              ),
                            ),

                            trailing: Text(
                              isRequestFullfilled
                                  ? "Fulfilled"
                                  : "Not fulfilled",
                              style: TextStyle(
                                fontSize: isWide ? 14 : context.resWidth(0.03),
                                color: isRequestFullfilled
                                    ? Colors.green
                                    : Colors.red,
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
                                subtitle: const Text(
                                  "Central North Blood Center",
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          isWide ? 32 : context.resHeight(0.02),
                          0,
                          0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Current donors locations out", //EDIT NEEDED: add a fetching function and an 'if' to validate if null
                              style: TextStyle(
                                fontSize: isWide ? 20 : context.resWidth(0.05),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          isWide ? 0 : context.resWidth(0.05),
                          isWide ? 16 : context.resHeight(0.05),
                          isWide ? 0 : context.resWidth(0.05),
                          isWide ? 16 : context.resHeight(0.05),
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
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final donors = asyncSnapshot.data!;
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                0,
                                0,
                                isWide ? 0 : context.resWidth(0.02),
                                0,
                              ),
                              child: isWide
                                  ? SizedBox(
                                      height: 400,
                                      width: double.infinity,
                                      // Bound the shared map's viewport-based label and
                                      // marker sizing without changing its interactions.
                                      child: MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          size: const Size(500, 400 / 0.45),
                                        ),
                                        child: DonorProximityMap(
                                          donors: donors,
                                          mapController: mapController,
                                        ),
                                      ),
                                    )
                                  : DonorProximityMap(
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
              ),
            ),
          ),
        );
      },
    );
  }
}
