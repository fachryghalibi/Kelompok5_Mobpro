import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  final String baseUrl = 'http://10.0.2.2/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'password': password,
        },
        encoding: Encoding.getByName('utf-8'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'success': true,
            'message': 'Login berhasil',
            'full_name': data['full_name'] ?? 'User',
            'email': data['email'] ?? '',
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Login gagal',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Error: Status code ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error during login: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}