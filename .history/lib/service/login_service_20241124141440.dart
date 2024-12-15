// login_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = 'http://10.0.2.2/api/login.php';
      
      // Create the request body
      Map<String, String> requestBody = {
        'email': email,
        'password': password,
      };

      // Debug: Print the request body
      print("Sending request body: ${json.encode(requestBody)}");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // Debug: Print complete response information
      print("Status code: ${response.statusCode}");
      print("Response headers: ${response.headers}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          return data;
        } catch (e) {
          print("JSON decode error: $e");
          return {
            'success': false,
            'message': 'Invalid response format',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (error) {
      print("Network error: $error");
      return {
        'success': false,
        'message': 'Network error: $error',
      };
    }
  }
}