import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // 1. Define your backend address (Replace with your actual API URL later)
  static const String baseUrl = 'https://your-api-url.com';

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
}
