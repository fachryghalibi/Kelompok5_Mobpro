// login_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl = 'http://10.0.2.2/api/login.php';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Membuat body request seperti yang berhasil
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json"
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (error) {
      print("Error: $error");
      return {
        'success': false,
        'message': 'Network error: $error',
      };
    }
  }
}