import 'dart:convert';
import 'package:blood_bank/models/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blood_bank/models/visits.dart';
import 'package:blood_bank/models/banks_detail.dart';
import 'package:latlong2/latlong.dart';

class AuthService {
  final storage = const FlutterSecureStorage();
  // 1. Define your backend address (Replace with your actual API URL later)
  static const String baseUrl = 'https://our-api-url.com';

  Future<Map<String, dynamic>> login(String nationalID, String password) async {
    try {
      // 2. Make the POST request to the server endpoint
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'national_id': nationalID, 'password': password}),
      );

      // 3. Process the response payload
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Success! Return the user data / tokens to the UI
        return responseData;
      } else {
        // Server rejected authentication. Extract the error message your backend team wrote
        // Adjust the key string ('message' or 'error') based on what your backend sends
        final String errorMessage =
            responseData['message'] ?? 'Invalid credentials';
        throw errorMessage;
      }
    } catch (e) {
      // Catch network timeouts, server drops, or thrown errors above
      if (e is String) {
        rethrow; // Sends the precise backend message directly to your UI snackbar
      }
      throw 'Cannot connect to server. Check your internet connection.';
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<double> fetchCredit() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/api/user/credit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', //EDIT NEEDED: fetch token from secure storage
        // JWT token can be added here if needed for authentication
      },
    );
    if (response.statusCode == 200) {
      final pageData = jsonDecode(response.body);
      return pageData['credit'].toDouble();
      // Process the data as needed
    } else {
      throw Exception('Failed to fetch credit amount');
    }
  }

  /* EDIT NEEDED: when the backend is ready, uncomment this function to fetch visits
  Future<List<Visit>> fetchVisits() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/api/user/visits'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', //EDIT completed: fetch token from secure storage
        // JWT token can be added here if needed for authentication
      },
    );
    if (response.statusCode == 200) {
      final visitData = jsonDecode(response.body);
      return (visitData['visits'] as List)
          .map((visit) => Visit.fromJson(visit))
          .toList();
      // Process the data as needed
    } else {
      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');
      throw Exception('Failed to fetch visits: ${response.statusCode}');
    }
  }*/
  //EDIT NEEDED: Temporary mock function to simulate fetching visits
  Future<List<Visit>> dummyFetchVisits() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      Visit(
        id: '1',
        visitDate: DateTime.now().subtract(const Duration(days: 1)),
        visitType: 'Blood Donation',
        visitLocation: 'City Hospital',
        visitStatus: 'Completed',
      ),
      Visit(
        id: '2',
        visitDate: DateTime.now().subtract(const Duration(days: 180)),
        visitType: 'Blood Test',
        visitLocation: 'Health Clinic',
        visitStatus: 'Pending',
      ),
    ];
  }

  static List<String> fetchLastSixMonths() {
    DateTime now = DateTime.now();
    List<String> months = [];
    List<String> monthsNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    for (int i = 5; i >= 0; i--) {
      int monthIndex = (now.month - i - 1) % 12;
      if (monthIndex < 0) {
        monthIndex += 12;
      }
      months.add(monthsNames[monthIndex]);
    }
    return months;
  }
}

Future<List<BanksDetails>> fetchBanks() async {
  try {
    final String banksJson = await rootBundle.loadString(
      'assets/data/banks_dummy.json',
    );

    final List<dynamic> jsonData = jsonDecode(banksJson);

    final List<BanksDetails> banksData = jsonData
        .map((json) => BanksDetails.fromJson(json))
        .toList();

    return banksData;
  } catch (e) {
    print('Error loading banks data: $e');
    rethrow;
  }
}

Future<List<Users>> fetchUsers() async {
  try {
    final String usersJson = await rootBundle.loadString(
      'assets/data/user_dummy.json',
    );

    final List<dynamic> jsonData = jsonDecode(usersJson);

    final List<Users> usersData = jsonData
        .map((json) => Users.fromJson(json))
        .toList();

    return usersData;
  } catch (e) {
    print('Error loading users data: $e');
    rethrow;
  }
}
