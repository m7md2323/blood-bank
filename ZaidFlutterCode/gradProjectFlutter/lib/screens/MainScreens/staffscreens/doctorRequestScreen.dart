import 'dart:async';
import 'dart:convert';

import 'package:blood_bank/models/users.dart';
import 'package:blood_bank/shared/network/AuthService.dart';
import 'package:blood_bank/shared/styles/components.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorRequestScreen extends StatefulWidget {
  const DoctorRequestScreen({super.key});

  @override
  State<DoctorRequestScreen> createState() => _DoctorRequestScreenState();
}

class _DoctorRequestScreenState extends State<DoctorRequestScreen> {
  @override
  bool isBottomSheetShown = false;
  Key scaffoldKey = GlobalKey<ScaffoldState>();
  String? bloodType;
  bool? isUrgent;
  bool isRequestFullfilled = false;
  TextEditingController unitCountController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  Timer? debounce;
  Map<String, dynamic>? donor;
  bool isLoading = false;
  String? errorMessage;
  late Future<List<Users>> usersFuture;
  @override
  void initState() {
    super.initState();
    usersFuture = dummyFetchUsers();
    /*searchController.addListener(() {
      print('Current text: ${searchController.text}');
    });*/
  }

  Future<void> searchDonor(String query) async {
    debounce?.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        donor = null;
        errorMessage = null;
        isLoading = false;
      });
      return;
    }

    debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        isLoading = true;
        errorMessage = null;
        donor = null;
      });

      try {
        final response = await http.get(
          Uri.parse(
            //EDIT NEEDED: put our API
            'https://YOUR_API_URL/api/donors/search'
            '?nationalId=${Uri.encodeQueryComponent(query.trim())}',
          ),
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);

          setState(() {
            donor = result;
          });
        } else if (response.statusCode == 404) {
          setState(() {
            errorMessage = 'No donor found.';
          });
        } else {
          setState(() {
            errorMessage = 'Something went wrong.';
          });
        }
      } catch (e) {
        if (!mounted) return;

        setState(() {
          errorMessage = 'Could not connect to the server.';
        });
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  Future dummyusers = dummyFetchUsers();

  String? searchedId;

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
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
          resizeToAvoidBottomInset: false, // Prevents the screen from shrinking
          appBar: AppBar(
            backgroundColor: mainColor,
            title: const Text(
              'welcome dr.doctorName',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(context.resWidth(0.02)),
                  //margin: EdgeInsets.all(context.resWidth(0.03)),
                  decoration: BoxDecoration(
                    color: mainColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.3,
                        ), // Shadow color with transparency
                        spreadRadius: 2, // How wide the shadow spreads
                        blurRadius: 10, // Softness of the shadow
                        offset: const Offset(
                          0,
                          4,
                        ), // Position displacement (X, Y)
                      ),
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(context.resWidth(0.2)),
                    ),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    "Type your patient's ID to search",

                    style: TextStyle(
                      fontSize: context.resWidth(0.05),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: context.resHeight(0.05)),
                Stack(
                  alignment: AlignmentGeometry.centerRight,
                  children: [
                    TextField(
                      controller: searchController,
                      //onChanged: searchDonor, EDIT NEEDED: potentially, move this to the searchbutton onpressed below
                      decoration: InputDecoration(
                        hintText: 'Enter donor national ID',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          searchedId = searchController.text.trim();
                        });
                      },
                      backgroundColor: Colors.redAccent,
                      splashColor: Colors.white,
                      child: Text("Search"),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (isLoading)
                  const CircularProgressIndicator()
                else if (donor != null)
                  Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(donor!['Name'] ?? 'Unknown'),
                      subtitle: Text(
                        'ID: ${donor!['nationalId']}\n'
                        'Blood type: ${donor!['bloodType']}',
                      ),
                      isThreeLine: true,
                    ),
                  )
                else if (true) // EDIT NEEDED: remove this when backend fetching is connected
                  FutureBuilder<List<Users>>(
                    future: usersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final dummyUsers = snapshot.data ?? [];
                      if (searchedId == null || searchedId!.trim().isEmpty) {
                        return const Text('Enter a user ID to search.');
                      }
                      final filteredUsers = dummyUsers
                          .where(
                            (user) => user.id.toString() == searchedId!.trim(),
                          )
                          .toList();

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: mainColor,
                            width: context.resWidth(0.01),
                          ),
                        ),
                        child: ListView.builder(
                          shrinkWrap:
                              true, //Note: removing this causes the page to crash
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];

                            if (user.id == searchController.text) {
                              debugPrint('Entered ID: "$searchedId"');
                              debugPrint(
                                'Available IDs: ${dummyUsers.map((user) => user.id).toList()}',
                              );
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'First name: ${user.Fname} \n \nLast name:${user.Lname}\n \nID: ${user.id}',

                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      labelText: 'Blood type',
                                      border: OutlineInputBorder(),
                                    ),
                                    initialValue: bloodType,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'O+',
                                        child: Text('O+'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'O-',
                                        child: Text('O-'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'A+',
                                        child: Text('A+'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'A-',
                                        child: Text('A-'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'B+',
                                        child: Text('B+'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'B-',
                                        child: Text('B-'),
                                      ),
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
                                    height: isWide
                                        ? 20
                                        : context.resHeight(0.03),
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
                                    height: isWide
                                        ? 20
                                        : context.resHeight(0.03),
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
                                  SizedBox(height: context.resHeight(0.03)),

                                  DefaultButton(
                                    buttonText: "Send request",
                                    function: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirm request'),
                                            content: Text(
                                              'Are you sure you want to make this request?',
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                    false,
                                                  ); // Dismiss and return false
                                                },
                                              ),
                                              TextButton(
                                                child: Text('send'),
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                    true,
                                                  ); // Dismiss and return true
                                                  // Perform your delete action here
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },

                          //EDIT NEEDED: add a button with a dialogue to confirm sending showing amount of credit to be sent
                        ),
                      );
                    },
                  )
                else if (errorMessage != null)
                  Text(errorMessage!),
              ],
            ),
          ),
        );
      },
    );
  }
}
