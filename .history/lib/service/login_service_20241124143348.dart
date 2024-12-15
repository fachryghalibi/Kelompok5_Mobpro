import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl = 'http://10.0.2.2/api/login.php';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Siapkan data
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'email': email.trim(),
          'password': password.trim(),
        },
      );

      // Debug log
      print('Request URL: $baseUrl');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Parse response
      final responseData = json.decode(response.body);
      return responseData;

    } catch (e) {
      print('Error during login: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}