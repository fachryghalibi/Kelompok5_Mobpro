import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  final String baseUrl = 'http://10.0.2.2/api/login.php';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Debug print
      print('Attempting login with email: $email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      // Debug prints
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);

      if (data['success'] == true) {
        // Sesuaikan dengan struktur JSON dari PHP
        return {
          'success': true,
          'message': data['message'],
          'full_name': data['data']['fullName'], // Perhatikan 'fullName' bukan 'full_name'
          'email': data['data']['email'],
          'id': data['data']['id'],
          'created_at': data['data']['createdAt']
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}