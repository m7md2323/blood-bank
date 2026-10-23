import 'dart:async';
import 'dart:convert';
import 'package:blood_bank/models/users.dart';
import 'package:blood_bank/shared/network/AuthService.dart';
import 'package:blood_bank/shared/styles/constants.dart';
import 'package:blood_bank/shared/styles/responsive_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransferCreditScreen extends StatefulWidget {
  const TransferCreditScreen({super.key});

  @override
  State<TransferCreditScreen> createState() => _TransferCreditScreenState();
}

class _TransferCreditScreenState extends State<TransferCreditScreen> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          'Search Donors',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentGeometry.centerRight,
              children: [
                TextField(
                  controller: searchController,
                  onChanged: searchDonor,
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
                      .where((user) => user.id.toString() == searchedId!.trim())
                      .toList();

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: mainColor,
                        width: context.resWidth(0.01),
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,//Note: removing this causes the page to crash
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];

                        if (user.id == searchController.text) {
                          debugPrint('Entered ID: "$searchedId"');
                          debugPrint(
                            'Available IDs: ${dummyUsers.map((user) => user.id).toList()}',
                          );
                          return ListTile(
                            title: Text(
                              'First name: ${user.Fname} \n \nLast name:${user.Lname}\n \nID: ${user.id}',

                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
  }
}
